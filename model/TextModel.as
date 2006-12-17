import util.*;
import model.*;
import flash.geom.*;

class model.TextModel extends Model implements IShapeModel {
	var x:Number;
	var y:Number;
	
	function TextModel() {
		super();
		x = 0;
		y = 0;
	}
	public function getTextPosition():Point {
		return new Point(x, y);
	}
	public function getTextAlign():String {
		return "left";
	}
	public function getTextVAlign():String {
		return "top";
	}
	public function getLeft():Number {
		return x;
	}
	public function getRight():Number {
		return x+getMetrics().textFieldWidth;
	}
	public function getTop():Number {
		return y;
	}
	public function getBottom():Number {
		return y+getMetrics().textFieldHeight;
	}
	public function getRectangle():Rectangle {
		var m = getMetrics();
		return new Rectangle(
			x, y,
			m.textFieldWidth,
			m.textFieldHeight
		);
	}
	private function getMetrics() {
		var textformat:TextFormat = new TextFormat();
		textformat.size = textstyle.fontSize;
		textformat.font = textstyle.fontFamily || "_sans";
		return textformat.getTextExtent(text);
	}
	public function getShapeType():String {
		return ShapeType.text;
	}
	function move(d):Void {
		x += d.x;
		y += d.y;
	}
	function scale(scaleX, scaleY):Void {
		super.scale(scaleX, scaleY);
		x = x * scaleX;
		y = y * scaleY;
	}
	function clone():IShapeModel {
		var m:TextModel = new TextModel();
		m.textstyle = textstyle.clone();
		m.text = text;
		m.x = x;
		m.y = y;
		return m;
	}
	public function getXMLNode():XMLNode {
		var node:XMLNode = createXMLElement("text");
		node.attributes.x = x.toString();
		node.attributes.y = y.toString();
		return node;
	}
	public function getSVGNode():XMLNode {
		var xml:XML = new XML();
		var group:XMLNode = xml.createElement("g");
		var str:String = text.split("\r\n").join("\n").split("\r").join("\n"); // 改行を\nに統一
		var lines:Array = str.split("\n");
		var metrics = getTextMetrics();
		var yoffset = metrics.ascent;
		var lineHeight = metrics.ascent + metrics.descent;
		for (var i=0; i<lines.length; i++) {
			var node:XMLNode = xml.createElement("text");
			node.appendChild(xml.createTextNode(lines[i]));
			node.attributes.style = textstyle.toSVGStyle();
			node.attributes.x = x.toString();
			node.attributes.y = (y + i*lineHeight + yoffset).toString();
			group.appendChild(node);
		}
		return group;
	}
	public static function createFromXMLNode(shape:XMLNode) {
		var a = new XMLAttributes(shape.attributes);
		var m:TextModel = new TextModel();
		if (shape.firstChild && shape.firstChild.nodeType == 3)
			m.text = shape.firstChild.nodeValue;
		m.textstyle = TextStyle.createFromAttr(shape.attributes.textstyle);
		
		m.x = a.getIntParam("x");
		m.y = a.getIntParam("y");
		return m;
	}
	public static function createFromSVGTextNode(shape:XMLNode, defaultStyle:Style):TextModel {
		var a = new XMLAttributes(shape.attributes);
		var m:TextModel = new TextModel();
		
		// text
		if (shape.firstChild && shape.firstChild.nodeType == 3) {
			var str:String = shape.firstChild.nodeValue;
			var newStr = "";
			var preChar = "";
			for (var i=0; i<str.length; i++) { // 連続したspaceを1つに
				var c = str.charAt(i);
				if (c == " " || c == "\r" || c == "\n") {
					if (preChar != " ") {
						newStr += " ";
					}
					preChar = " ";
				} else {
					newStr += c;
					preChar = c;
				}
			}
			m.text = newStr;
		}
		
		// attributes
		m.textstyle.color = a.getColorParam("color") || 0x000000;
		var fs = a.getIntParam("font-size");
		if (fs != null) {
			m.textstyle.fontSize = fs;
		}
		// style
		var svgStyle = (defaultStyle)
						? a.getStringParam("style", defaultStyle)
						: a.getStringParam("style");
		if (svgStyle) {
			svgStyle = svgStyle.split(" ").join("");
			svgStyle = svgStyle.split("\r").join("");
			svgStyle = svgStyle.split("\n").join("");
			m.textstyle = TextStyle.createFromAttr(svgStyle);
		}
		
		// Position
		m.x = a.getIntParam("x");
		var y = a.getIntParam("y");
		if (y != null) {
			y -= m.textstyle.fontSize;
			m.y = y;
		}
		
		return m;
	}
	
	public function intersects(rect:Rectangle):Boolean {
		return rect.intersects(getRectangle());
	}
}