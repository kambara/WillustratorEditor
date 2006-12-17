import util.*;
import canvas.layer.*;
import mx.core.*;
import flash.geom.*;
import flash.display.BitmapData;

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
		////shapesLayer.createChildren();
		shapesLayer.invalidate();
		
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
	
	public function getBitmap(size):Object {
		// shapesLayerをBitmap化
		var bmpData:BitmapData = new BitmapData(size.width, size.height, false, 0xFFFFFFFF);
		bmpData.draw(shapesLayer);
		/*
		var mc:MovieClip = this.createEmptyMovieClip("test_mc"+Math.random(), 100);
		mc.attachBitmap(bmpData, 100);
		mc.onMouseDown = function() {
			mc.startDrag(false);
		}
		mc.onMouseUp = function() {
			mc.stopDrag();
		}
		*/
		
		var raw:Array = [];
		for (var y=0; y<size.height; y++) {
			for (var x=0; x<size.width; x++) {
				var rgb:Number = bmpData.getPixel(x, y);
				raw.push(rgb);
			}
		}
		
		// 圧縮する
		var compress:Array = [];
		var color:Number = 0;
		var count:Number = 0;
		for (var i=0; i<raw.length; i++) {
			if (i == 0) { // First
				color = raw[0];
				count = 1;
			} else if (raw[i] != color) {
				//compress.push(color);
				//compress.push(count);
				compress.push( color.toString(32) );
				compress.push( (count==1) ? "" : count.toString() );
				color = raw[i];
				count = 1;
			} else {
				count++;
			}
			if (i == raw.length-1) {
				compress.push( color.toString(32) );
				compress.push( (count==1) ? "" : count.toString() );
			}
		}
		
		var compressStr = compress.join(",");
		trace((compressStr.length/1000) + "KB");
		//var rawStr = raw.join(",");
		//trace((rawStr.length/1000) + "KB-> " + (compressStr.length/1000) + "KB (" + (compressStr.length/rawStr.length) + ")");
		//trace(compressStr);
		
		return {
			width: size.width,
			height: size.height,
			data: compressStr
		};
		// dataは
		// 32bit,連続する数(1のときは空文字),
		// という文字列の連続
	}
}
