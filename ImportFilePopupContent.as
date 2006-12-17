import mx.controls.*;
import model.*;
import mx.events.EventDispatcher;

class ImportFilePopupContent extends mx.core.UIObject {
	private var filePath:TextInput;
	private var svgText:TextArea;
	private var loadButton:Button;
	private var dispatchEvent:Function;
	private var shapeCollection:ShapeCollection;
	
	function ImportFilePopup() {
	}
	public function init():Void {
	}
	public function createChildren():Void {
		this.createClassObject(TextArea, "svgText", 1, {
			_x: 10,
			_y: 10
		});
		svgText.setSize(270, 100);
		
		this.createClassObject(Button, "loadButton", 2, {
			label: "Import",
			_x: 10,
			_y: 120
		});
		
		// Event
		var self = this;
		loadButton.addEventListener("click", {
			click: function(evt) {
				self.parseSVG(self.svgText.text);
				self.dispatchEvent({type: "onImport", target: self});
			}
		});
	}
	public function draw():Void {
		super.draw();
	}
	
	public function getShapeCollection() {
		return shapeCollection;
	}
	function parseSVG(text) {
		var svg:XML = new XML(text);
		if (!svg.firstChild) return;
		
		var rootNode = getSVGRootNode(svg);
		if (rootNode == null) return;
		
		shapeCollection = new ShapeCollection();
		parseSVGNode(rootNode);
	}
	function getSVGRootNode(svg:XML) {
		for (var node:XMLNode = svg.firstChild; node != null; node = node.nextSibling) {
			if (node.nodeName == "svg") {
				return node;
			}
		}
		return null;
	}
	function parseSVGNode(parentNode, parentStyle) {
		if (parentStyle == undefined) {
			parentStyle = new Style();
			// svg default style?
		}
		for (var shapeNode:XMLNode = parentNode.firstChild; shapeNode != null; shapeNode = shapeNode.nextSibling) {
			var m:Model = null;
			switch( shapeNode.nodeName ) {
				case "g":
				case "a":
					if (shapeNode.attributes['style']) {
						var mergedStyle = Style.createFromString(shapeNode.attributes['style'], parentStyle);
						parseSVGNode(shapeNode, mergedStyle);
					} else {
						parseSVGNode(shapeNode, parentStyle);
					}
					break;
				case "path":
					m = PathModel.createFromSVGPathNode(shapeNode, parentStyle.clone());
					break;
				case "polygon":
					break;
				case "polyline":
					break;
				case "line":
					break;
					
				case "rect":
				case "ellipse":
				case "circle":
					m = BoxModel.createFromSVGRectNode(shapeNode);
					break;
					
				case "text":
					m = TextModel.createFromSVGTextNode(shapeNode);
					break;
					
			}
			if (m != null) {
				shapeCollection.addItem(m);
			}
		}
	}
}