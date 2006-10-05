import util.*;
import canvas.*;

class canvas.CanvasEventLayer extends AdvancedDrawingMC {
	private var canvas:Canvas;
	
	public function init(c:Canvas) {
		useHandCursor = false;
		drawFillRect(-2000, -2000, 4000, 4000,
					 1, 0x000000, 0,
					 0x000000, 0);
		this.canvas = c;
	}
	
	//
	// マウスイベント
	//
	private var mouseDownPos:Point;
	private var mouseUpPos:Point;
	
	private var longPressIntervalID:Number;
	private var previousMouseDownTime:Number;
	private var isMouseDown:Boolean = false;
	private var dragging:Boolean = false;
	
	public function onPress() {
		mouseDownPos = getCurrentMousePos();
		if (isDoubleClick()) {
			canvas.onDoubleClick(mouseDownPos);
		} else {
			isMouseDown = true;
			startLongPress();
			canvas.onNormalPress();
		}
	}
	public function onMouseMove() {
		if (isMouseDown) {
			if (dragging) {
				canvas.onDrag(mouseDownPos, getCurrentMousePos());
			} else {
				if (dragLongerThan(5)) { // 数ピクセル以上動かしたらドラッグ開始
					dragging = true;
					stopLongPress(); // ドラッグ開始後は長押しキャンセル
					canvas.onStartDrag(mouseDownPos);
				}
			}
		}
	}
	public function onMouseUp() {
		mouseUpPos = getCurrentMousePos();
		if (isMouseDown) {// ダブルクリック後は選択しない
			isMouseDown = false;
			stopLongPress();
			if (dragging) {
				dragging = false;
				canvas.onStopDrag(mouseDownPos, mouseUpPos);
			} else {
				// ただのクリック
			}
		}
	}
	
	
	
	private function getCurrentMousePos() {
		return new Point(_xmouse, _ymouse);
	}
	private function dragLongerThan(n):Boolean {
		var pos = getCurrentMousePos();
		if (Math.abs(pos.x - mouseDownPos.x) > n || Math.abs(pos.y - mouseDownPos.y) > n)
			return true;
		else
			return false;
	}
	
	private function onLongPress() {
		isMouseDown = false;
		dragging = false;
		stopLongPress();
		canvas.onLongPress(getCurrentMousePos());
	}
	private function startLongPress() {
		longPressIntervalID = setInterval(this, "onLongPress", 1300);
	}
	private function stopLongPress() {
		clearInterval(longPressIntervalID);
	}
	
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
}