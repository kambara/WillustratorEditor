import util.*;
import canvas.layer.*;
import mx.core.*;
import flash.geom.*;

//
// 各レイヤーやモデルの操作をするコントローラ
//
//class canvas.Canvas extends AdvancedDrawingMC {
class canvas.Canvas extends UIComponent {
	// initObj
	private var main:Main;
	
	// レイヤー
	private var backgroundLayer:BackgroundLayer;
	private var shapesLayer:ShapesLayer;
	private var createShapeLayer:CreateShapeLayer;
	private var editLayer:EditLayer;
	private var textEditLayer:TextEditLayer;
	private var selectionLayer:SelectionLayer;
	
	private var fixedOffset:Point;
	private var offset:Point;
	
	function Canvas() {
	}
	public function init():Void {
		super.init();
		fixedOffset = new Point(15, 40);
		offset = new Point(40, 40);
	}
	public function createChildren():Void {
		var serial = new SerialNumber();
		createObject("BackgroundLayer", "backgroundLayer", serial.getNumber(), {main: main});
		createObject("ShapesLayer", "shapesLayer", serial.getNumber(), {main: main});
		createObject("CreateShapeLayer", "createShapeLayer", serial.getNumber(), {main: main});
		createObject("EditLayer", "editLayer", serial.getNumber(), {main: main});
		createObject("TextEditLayer", "textEditLayer", serial.getNumber(), {main: main});
		createObject("SelectionLayer", "selectionLayer", serial.getNumber(), {main: main});
		
		onResize();
		Stage.addListener(this);
	}
	public function draw():Void {
		super.draw();
		backgroundLayer.invalidate();
		shapesLayer.createChildren();
		editLayer.startEdit();
	}
	function onResize() {
		var scrollPos = main.getCanvasScrollPosition();
		var scale = main.getCanvasScale() / 100;
		setPosition(StagePosition.getLeft() + fixedOffset.x + offset.x * scale - scrollPos.x * scale,
						StagePosition.getTop() + fixedOffset.y + offset.y * scale - scrollPos.y * scale);
	}
	
	//
	// Shapes Layer
	//
	public function updateOnlyShapes():Void {
		shapesLayer.createChildren();
	}
	public function dragSelectedShapes(d):Void {
		shapesLayer.dragSelectedShapes(d);
	}
	public function drawOnlyShapes():Void {
		shapesLayer.invalidate();
	}
	
	//
	// Create Layer
	//
	public function startCreate() {
		createShapeLayer.startCreate();
	}
	public function finishCreate() {
		createShapeLayer.finishCreate();
	}
	public function onAnotherToolSelected() {
		createShapeLayer.onAnotherToolSelected();
	}
	
	//
	// Edit Layer
	//
	public function startEdit() {
		editLayer.startEdit();
	}
	public function finishEdit() {
		editLayer.finishEdit();
	}
	public function startTextEdit(m) {
		editLayer.finishEdit();
		textEditLayer.startEdit(m);
	}
	public function changeEditType(type:String) {
		editLayer.changeEditType(type);
	}
	
	//
	// Selection Layer
	//
	public function startRectSelection(p) {
		selectionLayer.startSelect(p);
	}

	//
	// Canvas Size/Position
	//
	public function setPosition(x, y) {
		this._x = x;
		this._y = y;
	}
	public function moveToCenter() {
		var canvasSize:Size = main.getDocument().getCanvasSize();
		setPosition(StagePosition.getLeft() + (Stage.width - canvasSize.width)/2,
						StagePosition.getTop() + (Stage.height - canvasSize.height)/2);
	}
	
	//
	// zoom
	//
	public function onScaleChanged() {
		this._xscale = main.getCanvasScale();
		this._yscale = main.getCanvasScale();
		editLayer.invalidate();
		shapesLayer.invalidate();
		onResize();
	}
}
