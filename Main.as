import util.*;
import model.*;
import canvas.*;
import tools.*;
import property.*;
import mx.controls.*;
import flash.geom.*;

class Main {
	private var document:Document;
	private var undoBuffer:UndoBuffer;
	private var selectedShapes:ShapeCollection;
	private var currentTool:String;
	private var contextMenu;
	private var defaultShapeParams = {
		pathFill: 0xFFFFFF,
		pathStroke: 0x000000,
		pathStrokeWidth: 1,
		
		boxFill: 0xFFFFFF,
		boxStroke: 0x000000,
		boxStrokeWidth: 1,
		
		textFontSize: 20,
		textColor: 0x000000
	};
	
	function Main() {
		if (_root.source_url) {
			loadSrc(_root.source_url);
		} else {
			loadLocalSrc("test2.xml");
		}
		selectedShapes = new ShapeCollection();
		currentTool = ToolType.select;
		contextMenu = new CanvasContextMenu(this);
	}
	
	//
	// getter
	//
	public function getDocument():Document {
		return document;
	}
	private function getCanvas():Canvas {
		return _root.canvas;
	}
	private function getBar():Bar {
		return _root.bar;
	}
	private function getPropertyPanel():PropertyPanel {
		return _root.propertyPanel;
	}
	public function getSelectedShapes():ShapeCollection {
		return selectedShapes;
	}
	public function getSaveUrl():String {
		return _root.save_url;
	}
	public function getCanvasScale() {
		var scale = _root.zoomComboBox.getValue();
		return (scale) ? scale : 100;
	}
	public function getCanvasScrollPosition():Point {
		var pos = _root.canvasScroll.getPosition();
		return (pos) ? pos : new Point(0, 0);
	}
	
	//
	// ToolButton
	//
	public function getCurrentTool():String {
		return currentTool;
	}
	public function updateToolButtons() {
		getBar().updateToolButtons()
	}
	public function onToolSelected(type) {
		if (type && type != getCurrentTool()) {
			getCanvas().onAnotherToolSelected(); // 作りかけの線などの処理
			currentTool = type;
			updateToolButtons();
			unselectShape();
			getCanvas().startCreate();
			/*
			if (type == ToolType.box) {
				var self = this;
				_root.onEnterFrame = function() {
					_root.createObject("BoxToolPropertyPanel", "propertyPanel", 1, {main:self});
					delete(_root.onEnterFrame);
				}
			}
			*/
		}
	}
	private function selectSelectTool() {
		onToolSelected(ToolType.select);
	}
	
	//
	// Property Panel
	//
	private function updatePropertyPanel() {
		hidePropertyPanel();
		if (selectedShapes.getLength() > 1) {
		} else if (selectedShapes.getLength() == 1) {
			var m = selectedShapes.getItemAt(0);
			var self = this;
			_root.onEnterFrame = function() {
				_root.createObject(m.getShapeType()+"PropertyPanel", "propertyPanel", 1, {main:self, shapeModel:m});
				delete(_root.onEnterFrame);
			}
		} else {
			showCanvasPropertyPanel();
		}
	}
	private function showCanvasPropertyPanel() {
		hidePropertyPanel();
		var self = this;
		_root.onEnterFrame = function() {
			_root.createObject("CanvasPropertyPanel", "propertyPanel", 1, {main:self, shapeModel:self.getDocument()});
			delete(_root.onEnterFrame);
		}
	}
	private function hidePropertyPanel() {
		if (_root.propertyPanel) {
			_root.destroyObject("propertyPanel");
		}
	}
	public function onPropertyChanged() {
		getCanvas().invalidate();
	}
	public function isPropertyFocused() {
		if (!_root.focusManager.getFocus()
			|| _root.focusManager.getFocus() == _root.canvas) {
			return false;
		} else {
			return true;
		}
		//return (_root.propertyPanel) ? _root.propertyPanel.isFocused() : false;
	}
	public function changeEditType(type:String) {
		getCanvas().changeEditType(type); // path, size...
	}
	
	//
	// Shape Selection
	//
	public function selectShape(m):Void {
		selectedShapes.removeAll();
		if (m != null) {
			selectedShapes.addItem(m);
			contextMenu.enableCopy();
			getCanvas().startEdit();
			updatePropertyPanel();
		} else {
			getCanvas().finishEdit();
		}
	}
	public function addSelectedShape(m):Void {
		if (m != null) {
			if ( ! selectedShapes.removeItem(m)) {
				selectedShapes.addItem(m);
			}
			getCanvas().startEdit();
			updatePropertyPanel();
		}
	}
	public function selectShapesToIntersect(rect:Rectangle):Void {
		var sc:ShapeCollection = document.getShapeCollection().getShapeCollectionToIntersect(rect);
		if ( ! Key.isDown(Key.SHIFT)) {
			selectedShapes.removeAll();
		}
		if (sc.getLength() > 0) {
			for (var i=0; i<sc.getLength(); i++) {
				var m = sc.getItemAt(i);
				if (!selectedShapes.have(m)) {
					selectedShapes.addItem(m);
				}
			}
		}
		contextMenu.enableCopy();
		getCanvas().startEdit();
		updatePropertyPanel();
	}
	public function unselectShape():Void {
		selectedShapes.removeAll();
		contextMenu.disableCopy();
		getCanvas().finishEdit();
		hidePropertyPanel();
	}
	public function onBackgroundSelected(p:Point):Void {
		getCanvas().startRectSelection(p);
	}
	public function removeSelectedShapes():Void {
		getCanvas().finishEdit();
		for (var i=0; i<selectedShapes.getLength(); i++) {
			document.getShapeCollection().removeItem(selectedShapes.getItemAt(i));
		}
		selectedShapes.removeAll();
		getCanvas().updateOnlyShapes();
		log();
	}
	public function moveSelectedShapes(d):Void {
		selectedShapes.move(d, getDocument().isSnapping());
		getCanvas().invalidate();
		getPropertyPanel().invalidate();
		log();
	}
	public function copySelectedShapes(d):Void {
		var copiedShapes = selectedShapes.clone();
		copiedShapes.move(d, getDocument().isSnapping());
		for (var i=0; i<copiedShapes.getLength(); i++) {
			document.getShapeCollection().addItem(copiedShapes.getItemAt(i));
		}
		unselectShape();
		getCanvas().invalidate();
		log();
	}
	public function getIndexOfSelectedShape():Number {
		// 一番上が0
		if (selectedShapes.getLength() != 1) return null;
		var m = selectedShapes.getItemAt(0);
		return document.getShapeCollection().getIndexOf(m);
	}
	public function changeLayerOfSelectedShape(index:Number):Void {
		if (selectedShapes.getLength() != 1) return;
		var m = selectedShapes.getItemAt(0);
		document.getShapeCollection().moveIndexOf(m, index);
		selectShape(document.getShapeCollection().getItemAt(index));
		getCanvas().invalidate();
		log();
	}
	
	//
	// Clipboard Copy, Paste
	//
	public function copyOnClipboardSelectedShapes():Void {
		if (selectedShapes.getLength() == 0) return;
		var xml:XML = new XML();
		var shapes:XMLNode = xml.createElement("shapes");
		for (var i=0; i<selectedShapes.getLength(); i++) {
			var shapeModel:IShapeModel = selectedShapes.getItemAt(i);
			shapes.appendChild(shapeModel.getXMLNode());
		}
		xml.appendChild(shapes);
		var so:SharedObject = SharedObject.getLocal("clipboard");
		so.data.shapes = xml.toString();
		so.flush();
	}
	public function pasteShapesFromClipboard():Void {
		var so:SharedObject = SharedObject.getLocal("clipboard");
		if (!so.data.shapes || so.data.shapes == "") return;
		var xml:XML = new XML(so.data.shapes);
		var rootNode:XMLNode = xml.firstChild;
		if (rootNode.nodeName != "shapes") return;
		document.addShapesFromXMLNode(rootNode);
		getCanvas().invalidate();
	}
	public function existShapesOnClipboard():Boolean {
		var so:SharedObject = SharedObject.getLocal("clipboard");
		if (!so.data.shapes || so.data.shapes == "") {
			return false;
		} else {
			return true;
		}
	}
	
	//
	// Shape Event
	//
	public function onShapeStartDrag(shapeModel:IShapeModel):Void {
		if ( ! selectedShapes.have(shapeModel)) {
			selectShape(shapeModel);
		}
	}
	public function onShapeDrag(d:Point):Void {
		getCanvas().dragSelectedShapes(d);
		updateAfterEvent();
	}
	public function onShapeDoubleClick(m:IShapeModel):Void {
		getCanvas().startTextEdit(m);
	}
	
	//
	// Edit Event
	//
	public function onEditChanged():Void {
		getCanvas().drawOnlyShapes();
		getPropertyPanel().invalidate();
	}
	
	//
	// Create Event
	//
	public function createPath(vertices, closepath) {
		if (vertices.getLength() >= 2) {
			var path:PathModel = new PathModel();
			path.vertices = vertices.clone();
			path.closepath = closepath;
			if ( ! closepath) {
				path.style.fillOpacity = 0;
			}
			// default color
			path.style.fill = defaultShapeParams.pathFill;
			path.style.stroke = defaultShapeParams.pathStroke;
			path.style.strokeWidth = defaultShapeParams.pathStrokeWidth;
			document.getShapeCollection().addItem(path);
		}
		getCanvas().finishCreate();
		getCanvas().invalidate();
		selectSelectTool();
		log();
	}
	public function createBox(x, y, w, h, figureType) {
		if (w>5 && h>5) {
			var box:BoxModel = new BoxModel();
			box.x = x;
			box.y = y;
			box.width = w;
			box.height = h;
			box.round = 0;
			if (figureType) {
				box.figure = figureType;
			}
			// default color
			box.style.fill = defaultShapeParams.boxFill;
			box.style.stroke = defaultShapeParams.boxStroke;
			box.style.strokeWidth = defaultShapeParams.boxStrokeWidth;
			document.getShapeCollection().addItem(box);
		}
		getCanvas().finishCreate();
		getCanvas().invalidate();
		selectSelectTool();
		log();
	}
	public function createText(text, x, y) {
		if (text != "") {
			var tm:TextModel = new TextModel();
			tm.x = x;
			tm.y = y;
			tm.setText(text);
			tm.textstyle.fontSize = defaultShapeParams.textFontSize;
			tm.textstyle.color = defaultShapeParams.textColor;
			document.getShapeCollection().addItem(tm);
		}
		getCanvas().invalidate();
		selectSelectTool();
		log();
	}
	
	//
	// Zoom Event
	//
	public function onZoomChanged():Void {
		getCanvas().onScaleChanged();
	}
	
	//
	// Scroll
	//
	public function onScroll():Void {
		getCanvas().onResize();
	}
	
	//
	// Load Source
	//
	private function onLoadSrc(src:String) {
		var xml:XML = new XML(src);
		document = new Document();
		document.parseSrc(xml);
		_root.createObject("Canvas", "canvas", 0, {main: this});
		// propertyPanelが1
		_root.createObject("CanvasScroll", "canvasScroll", 2, {main: this});
		
		_root.createObject("Bar", "bar", 4, {main: this});
		_root.createObject("ZoomComboBox", "zoomComboBox", 5, {main: this});
		
		undoBuffer = new UndoBuffer(10);
		Key.addListener(this);
		log();
	}
	
	private function loadSrc(url) {
		var receiver:LoadVars = new LoadVars();
		var self = this;
		receiver.onData = function(src) {
			self.onLoadSrc(src);
		}
		var sender:LoadVars = new LoadVars();
		sender.rnd = Math.random().toString();
		sender.sendAndLoad(url, receiver, "GET");
	}
	
	private function loadLocalSrc(url) {
		var receiver:LoadVars = new LoadVars();
		var self = this;
		receiver.onData = function(src) {
			self.onLoadSrc(src);
		}
		receiver.load(url);
	}
	
	//
	// Undo/Redo
	//
	private function resetCanvas(doc) {
		_root.canvas.removeMovieClip();
		document = doc.clone();
		_root.createObject("Canvas", "canvas", 0, {main: this});
	}
	public function log() {
		undoBuffer.addItem(document.clone());
	}
	function onKeyDown() {
		if (Key.isDown(Key.CONTROL)) {
			if (Key.isDown(90) || Key.isDown(191)) { // C-z or C-/
				var item = undoBuffer.undo();
				if (item != null)
					resetCanvas(item);
			} else if (Key.isDown(89) || Key.isDown(190)) { // C-y or C-.
				var item = undoBuffer.redo();
				if (item != null)
					resetCanvas(item);
			}
		}
	}
}