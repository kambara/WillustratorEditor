import util.*;
import model.*;
import canvas.*;
import flash.geom.*;

class canvas.shape.Shape extends WillustratorDrawingMC {
	private var shapeModel; // あえて型指定しない。描画専用。
	private var main:Main;
	private var draggingFrame:WillustratorDrawingMC;
	
	function init(m:IShapeModel, main, frame) {
		this.shapeModel = m;
		this.main = main;
		this.draggingFrame = frame;
		draw();
	}
	private function draw():Void { // Abstract
	}
	public function drawWhileDragging(d:Point):Void { // Abstract
	}
	private function getCurrentMousePos():Point {
		return new Point(_xmouse, _ymouse);
	}
	
	//
	// ダブルクリック判定
	//
	private var previousMouseDownTime:Number;
	private function isDoubleClick() {
		var now = getTimer();
		if (previousMouseDownTime) {
			var interval = now - previousMouseDownTime;
			if (interval<200) {
				return true;
			}
		}
		previousMouseDownTime = now;
		return false;
	}
	//
	// マウスイベント
	//
	private var doubleClicked = false;
	private var dragging:Boolean = false;
	private var dragStartMousePos:Point;
	function onPress() { // 選択/追加選択/ドラッグ開始/ダブルクリック
		dragging = false;
		if (Key.isDown(Key.SHIFT)) {
			main.addSelectedShape(shapeModel);
		} else if (isDoubleClick()) {
			 doubleClicked = true;
		} else {
			dragStartMousePos = getCurrentMousePos();
			dragging = true;
			main.onShapeStartDrag(shapeModel);
		}
	}
	function onMouseMove() {
		if (dragging) { // ドラッグ
			var d:Point = getCurrentMousePos().subtract(dragStartMousePos);
			main.onShapeDrag(d);
		}
	}
	function onMouseUp() { // コピー/移動
		if (doubleClicked) {
			doubleClicked = false;
			main.onShapeDoubleClick(shapeModel);
		}
		if (dragging) {
			dragging = false;
			draggingFrame.clear();
			var d:Point = getCurrentMousePos().subtract(dragStartMousePos);
			if (Math.abs(d.x)>2 || Math.abs(d.y)>2) { // クリックかドラッグ
				if (Key.isDown(Key.CONTROL)) {
					main.copySelectedShapes(d);
				} else {
					main.moveSelectedShapes(d);
				}
			}
		}
	}
}
