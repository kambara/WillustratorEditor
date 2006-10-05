import util.*;
import model.*;
import flash.geom.*;

class model.PathModel extends Model implements IShapeModel {
	var vertices:Vertices;
	var closepath:Boolean;
	var startarrow:String;
	var endarrow:String;
	var style:Style;
	
	function PathModel() {
		super();
		vertices = new Vertices();
		closepath = false;
		startarrow = "none";
		endarrow = "none";
		style = new Style();
	}
	public function getShapeType():String {
		return ShapeType.path;
	}
	public function getCenterPoint():Point {
		var rect:Rectangle = vertices.getRectangle();
		return new Point(rect.left + rect.width/2, rect.top + rect.height/2);
	}
	public function move(d):Void {
		vertices.move(d);
	}
	public function scale(scaleX, scaleY):Void {
		vertices.scale(scaleX, scaleY);
	}
	public function getTextPosition():Point {
		return getCenterPoint();
	}
	public function getTextAlign():String {
		return "center";
	}
	public function getTextVAlign():String {
		return "middle";
	}
	public function getLeft():Number {
		return vertices.getLeft();
	}
	public function getRight():Number {
		return vertices.getRight();
	}
	public function getTop():Number {
		return vertices.getTop();
	}
	public function getBottom():Number {
		return vertices.getBottom();
	}
	public function getRectangle():Rectangle {
		return vertices.getRectangle();
	}
	public function clone():IShapeModel {
		var m:PathModel = new PathModel();
		m.textstyle = textstyle.clone();
		m.text = text;
		m.style = style.clone();
		m.vertices = vertices.clone();
		m.closepath = closepath;
		m.startarrow = startarrow;
		m.endarrow = endarrow;
		return m;
	}
	public function getXMLNode():XMLNode {
		var node:XMLNode = createXMLElement("path");
		node.attributes.style = style.toString();
		node.attributes.vertices = vertices.toString();
		node.attributes.closepath = (closepath) ? "1" : "0";
		node.attributes.startarrow = startarrow;
		node.attributes.endarrow = endarrow;
		return node;
	}
	public function getSVGNode():XMLNode {
		var xml:XML = new XML();
		var group:XMLNode = xml.createElement("g");
		var node:XMLNode = xml.createElement("path");
		node.attributes.style = style.toString();
		node.attributes.d = getPathD();
		group.appendChild(node);
		
		// text node
		if (text) {
			var str:String = text.split("\r\n").join("\n").split("\r").join("\n"); // 改行を\nに統一
			var lines:Array = str.split("\n");
			
			var metrics = getTextMetrics();
			var yoffset = metrics.ascent;
			var lineHeight = metrics.ascent + metrics.descent;
			
			var cx = (getLeft()+getRight())/2; 
			var cy = (getTop()+getBottom())/2;
			var texty = cy - metrics.height/2;
			
			for (var i=0; i<lines.length; i++) {
				var node:XMLNode = xml.createElement("text");
				node.appendChild(xml.createTextNode(lines[i]));
				node.attributes.style = textstyle.toSVGStyle();
				var textx = cx - getTextMetrics(lines[i]).width/2;
				node.attributes.x = textx.toString();
				//node.attributes.x = cx.toString();
				node.attributes.y = (texty + i*lineHeight + yoffset).toString();
				group.appendChild(node);
			}
		}
		return group;
	}
	private function getPathD() {
		var dlist:Array = new Array();
		dlist.push([
					"M",
					vertices.getItemAt(0).getAnchorFormatString()
					].join(" ")); // 最初のvertex
		
		for (var i=1; i<vertices.getLength(); i++) { // 次のvertex
			if (vertices.getItemAt(i).getControlA().exist() || vertices.getItemAt(i-1).getControlB().exist()) {
				dlist.push([ "C",
								vertices.getItemAt(i-1).getControlB().toString() || vertices.getItemAt(i-1).getAnchorFormatString(),
								vertices.getItemAt(i).getControlA().toString() || vertices.getItemAt(i).getAnchorFormatString(),
								vertices.getItemAt(i).getAnchorFormatString()
							 ].join(" "));
			} else {
				
				dlist.push(["L", vertices.getItemAt(i).getAnchorFormatString()].join(" "));
			}
		}
		
		if (closepath) {
			if (vertices.getItemAt(0).getControlA().exist() || vertices.getLastItem().getControlB().exist()) {
				dlist.push([ "C",
								vertices.getLastItem().getControlB().toString() || vertices.getLastItem().getAnchorFormatString(),
								vertices.getItemAt(0).getControlA().toString() || vertices.getItemAt(0).getAnchorFormatString(),
								vertices.getItemAt(0).getAnchorFormatString()
							 ].join(" "));
			}
			dlist.push("Z");
		}
		return dlist.join(" ");
	}
	public static function createFromXMLNode(shape:XMLNode):PathModel {
		var a = new XMLAttributes(shape.attributes);
		var m:PathModel = new PathModel();
		if (shape.firstChild && shape.firstChild.nodeType == 3)
			m.text = shape.firstChild.nodeValue;
		m.textstyle = TextStyle.createFromAttr(shape.attributes.textstyle);
		
		m.style = Style.createFromString(a.getStringParam("style"));
		m.vertices = Vertices.createFromString(a.getStringParam("vertices"));
		m.closepath = (a.getIntParam("closepath") > 0);
		m.startarrow = a.getStringParam("startarrow");
		m.endarrow = a.getStringParam("endarrow");
		return m;
	}
	public static function createFromSVGPathNode(shape:XMLNode):PathModel {
		var a = new XMLAttributes(shape.attributes);
		var m:PathModel = new PathModel();
		
		var d = a.getStringParam("d");
		m.vertices = Vertices.createFromSVGPath(d);
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
		var points:Array = vertices.getPoints();
		for (var i=0; i<points.length; i++) {
			var p:Point = points[i];
			if (rect.contains(p.x, p.y)) {
				return true;
			}
		}
		return false;
	}
}