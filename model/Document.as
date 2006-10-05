import util.*;
import model.*;

class model.Document {
	var shapeCollection:ShapeCollection;
	var canvasSize:Size;
	var canvasColor:Number;
	var snapping:Boolean;
	
	function Document() {
		shapeCollection = new ShapeCollection();
	}
	public function getShapeCollection():ShapeCollection {
		return shapeCollection;
	}
	public function setShapeCollection(value:ShapeCollection):Void {
		this.shapeCollection = value;
	}
	public function getCanvasSize():Size {
		return canvasSize;
	}
	public function setCanvasSize(size:Size):Void {
		canvasSize = size;
	}
	public function getCanvasColor():Number {
		return canvasColor;
	}
	public function setCanvasColor(value:Number):Void {
		this.canvasColor = value;
	}
	public function enableSnapping():Void {
		this.snapping = true;
	}
	public function disableSnapping():Void {
		this.snapping = false;
	}
	public function isSnapping():Boolean {
		return this.snapping;
	}
	
	public function clone() {
		var doc = new Document();
		doc.setShapeCollection(this.shapeCollection.clone());
		doc.setCanvasSize(this.canvasSize.clone());
		doc.setCanvasColor(this.canvasColor);
		return doc;
	}
	
	//
	// XML出力
	//
	public function getXML() {
		var xml:XML = new XML();
		var shapes:XMLNode = xml.createElement("canvas");
		shapes.attributes.height = canvasSize.height.toString();
		shapes.attributes.width = canvasSize.width.toString();
		shapes.attributes.backgroundColor = ColorName.intToHtmlColor(canvasColor);
		for (var i=0; i<shapeCollection.getLength(); i++) {
			var shapeModel:IShapeModel = shapeCollection.getItemAt(i);
			shapes.appendChild(shapeModel.getXMLNode());
		}
		xml.appendChild(shapes);
		return xml;
	}
	public function getSVG() {
		var svg:XML = new XML();
		svg.xmlDecl = '<?xml version="1.0" encoding="UTF-8"?>';
		svg.docTypeDecl = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" '
		                       + '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';
		
		var rootNode:XMLNode = svg.createElement("svg");
		rootNode.attributes.xmlns = "http://www.w3.org/2000/svg";
		rootNode.attributes.height = canvasSize.height.toString();
		rootNode.attributes.width = canvasSize.width.toString();
		/*
		rootNode.attributes.style = "background-color: "
		                                     + ColorName.intToHtmlColor(canvasColor);
		*/
		var bg:XMLNode = svg.createElement("rect");
		bg.attributes.x = "0";
		bg.attributes.y = "0";
		bg.attributes.width = canvasSize.width.toString();
		bg.attributes.height = canvasSize.height.toString();
		bg.attributes.fill = ColorName.intToHtmlColor(canvasColor);
		rootNode.appendChild(bg);
		
		for (var i=0; i<shapeCollection.getLength(); i++) {
			var shapeModel:IShapeModel = shapeCollection.getItemAt(i);
			rootNode.appendChild(shapeModel.getSVGNode()); // TODO: getSVGNodeを実装する
		}
		svg.appendChild(rootNode);
		return svg;
	}
	
	//
	// XMLパース
	//
	public function addShapesFromXMLNode(shapes:XMLNode) {
		for (var shapeNode:XMLNode = shapes.firstChild; shapeNode != null; shapeNode = shapeNode.nextSibling) {
			var m:Model = null;
			switch( shapeNode.nodeName ) {
				case "box":
					m = BoxModel.createFromXMLNode(shapeNode);
					break;
				case "path":
					m = PathModel.createFromXMLNode(shapeNode);
					break;
				case "text":
					m = TextModel.createFromXMLNode(shapeNode);
					break;
			}
			if (m != null) {
				shapeCollection.addItem(m);
			}
		}
	}
	public function parseSrc(src:XML) {
		var rootNode:XMLNode = src.firstChild;
		if (rootNode.nodeName != "canvas") {
			return;
		}
		var a = new XMLAttributes(rootNode.attributes);
		canvasSize = new Size(a.getIntParam("width"), a.getIntParam("height"));
		canvasColor = a.getColorParam("backgroundColor");
		addShapesFromXMLNode(rootNode);
		/*
		for (var shapeNode:XMLNode = rootNode.firstChild; shapeNode != null; shapeNode = shapeNode.nextSibling) {
			var m:Model = null;
			switch( shapeNode.nodeName ) {
				case "box":
					m = BoxModel.createFromXMLNode(shapeNode);
					break;
				case "path":
					m = PathModel.createFromXMLNode(shapeNode);
					break;
				case "text":
					m = TextModel.createFromXMLNode(shapeNode);
					break;
			}
			if (m != null) {
				shapeCollection.addItem(m);
			}
		}
		*/
	}
}
