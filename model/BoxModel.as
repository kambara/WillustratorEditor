import util.*;
import model.*;
import flash.geom.*;

class model.BoxModel extends Model implements IShapeModel {
	var x:Number;
	var y:Number;
	var width:Number;
	var height:Number;
	var round:Number;
	var figure:String;
	var style:Style;
	
	function BoxModel() {
		super();
		style = new Style();
		x = 0;
		y = 0;
		width = 0;
		height = 0;
		round = 0;
		figure = "rect";
	}
	function getShapeType():String {
		return ShapeType.box;
	}
	public function getTextPosition():Point {
		return new Point(x+width/2, y+height/2);
	}
	public function getTextAlign():String {
		return "center";
	}
	public function getTextVAlign():String {
		return "middle";
	}
	public function getLeft():Number {
		return x;
	}
	public function getRight():Number {
		return x+width;
	}
	public function getTop():Number {
		return y;
	}
	public function getBottom():Number {
		return y+height;
	}
	public function getRectangle():Rectangle {
		return new Rectangle(
			x, y,
			width, height
		);
	}
	function move(d):Void {
		x += d.x;
		y += d.y;
	}
	function scale(scaleX, scaleY):Void {
		x = x * scaleX;
		y = y * scaleY;
		width = width * scaleX;
		height = height * scaleY;
		if (width < 0) {
			width = -width;
			x = x - width;
		}
		if (height < 0) {
			height = -height;
			y = y - height;
		}
	}
	function clone():IShapeModel {
		var m:BoxModel = new BoxModel();
		m.textstyle = textstyle.clone();
		m.text = text;
		m.style = style.clone();
		m.x = x;
		m.y = y;
		m.width = width;
		m.height = height;
		m.round = round;
		m.figure = figure;
		return m;
	}
	public function getXMLNode():XMLNode {
		var node:XMLNode = createXMLElement("box");
		node.attributes.style = style.toString();
		node.attributes.x = x.toString();
		node.attributes.y = y.toString();
		node.attributes.width = width.toString();
		node.attributes.height = height.toString();
		node.attributes.round = round.toString();
		node.attributes.figure = figure;
		return node;
	}
	public function getSVGNode():XMLNode {
		var xml:XML = new XML();
		var group:XMLNode = xml.createElement("g");
		// box node
		var node:XMLNode = xml.createElement(figure);
		node.attributes.style = style.toString();
		if (figure == "rect") {
			node.attributes.x = x.toString();
			node.attributes.y = y.toString();
			node.attributes.width = width.toString();
			node.attributes.height = height.toString();
			node.attributes.rx = round.toString();
			node.attributes.ry = round.toString();
		} else if (figure == "ellipse") {
			var rx = width/2;
			var ry = height/2;
			node.attributes.cx = (x+rx).toString();
			node.attributes.cy = (y+ry).toString();
			node.attributes.rx = rx.toString();
			node.attributes.ry = ry.toString();
		}
		group.appendChild(node);
		
		// text node
		if (text) {
			var str:String = text.split("\r\n").join("\n").split("\r").join("\n"); // 改行を\nに統一
			var lines:Array = str.split("\n");
			
			var metrics = getTextMetrics();
			var yoffset = metrics.ascent;
			var lineHeight = metrics.ascent + metrics.descent;
			
			var cx = x + width/2;
			var cy = y+ height/2;
			//var textx = cx - metrics.width/2;
			var texty = cy - metrics.height/2;
			
			for (var i=0; i<lines.length; i++) {
				var node:XMLNode = xml.createElement("text");
				node.appendChild(xml.createTextNode(lines[i]));
				node.attributes.style = textstyle.toSVGStyle();
				//node.attributes.x = cx.toString();
				var textx = cx - getTextMetrics(lines[i]).width/2;
				node.attributes.x = textx.toString();
				node.attributes.y = (texty + i*lineHeight + yoffset).toString();
				group.appendChild(node);
			}
		}
		
		return group;
	}
	public static function createFromXMLNode(shape:XMLNode):BoxModel {
		var a = new XMLAttributes(shape.attributes);
		var m:BoxModel = new BoxModel();
		if (shape.firstChild && shape.firstChild.nodeType == 3)
			m.text = shape.firstChild.nodeValue;
		m.textstyle = TextStyle.createFromAttr(shape.attributes.textstyle);
		
		m.style = Style.createFromString(a.getStringParam("style"));
		m.x = a.getIntParam("x");
		m.y = a.getIntParam("y");
		m.width = a.getIntParam("width");
		m.height = a.getIntParam("height");
		m.round = a.getIntParam("round");
		m.figure = a.getStringParam("figure");
		return m;
	}
	public static function createFromSVGRectNode(shape:XMLNode):BoxModel {
		var a = new XMLAttributes(shape.attributes);
		var m:BoxModel = new BoxModel();
		
		// attributes
		switch (shape.nodeName) {
			case "rect":
				m.x = a.getIntParam("x");
				m.y = a.getIntParam("y");
				m.width = a.getIntParam("width");
				m.height = a.getIntParam("height");
				m.round = a.getIntParam("ry");
				m.round = a.getIntParam("rx");
				m.figure = "rect";
				break;
			case "ellipse":
				var cx = a.getIntParam("cx");
				var cy = a.getIntParam("cy");
				var rx = a.getIntParam("rx");
				var ry = a.getIntParam("ry");
				m.x = cx - rx;
				m.y = cy - ry;
				m.width = rx * 2;
				m.height = ry * 2;
				m.figure = "ellipse";
				break;
			case "circle":
				var cx = a.getIntParam("cx");
				var cy = a.getIntParam("cy");
				var r = a.getIntParam("r");
				m.x = cx - r;
				m.y = cy - r;
				m.width = r * 2;
				m.height = r * 2;
				m.figure = "ellipse";
				break;
		}
		// fill attributes
		m.style.fill = a.getColorParam("fill") || 0x000000;
		m.style.stroke = a.getColorParam("stroke");
		var sw = a.getIntParam("stroke-width");
		if (sw != null) {
			m.style.strokeWidth = sw;
		}
		// style
		var svgStyle = a.getStringParam("style");
		if (svgStyle) {
			svgStyle = svgStyle.split(" ").join("");
			svgStyle = svgStyle.split("\r").join("");
			svgStyle = svgStyle.split("\n").join("");
			m.style = Style.createFromString(svgStyle);
		}
		return m;
	}
	
	public function intersects(rect:Rectangle):Boolean {
		return rect.intersects(getRectangle());
	}
}