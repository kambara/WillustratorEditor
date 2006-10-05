import util.*;
import flash.geom.*;

class canvas.edit.handle.Handle extends AdvancedDrawingMC {
	//
	// Handle Class
	// ドラッグすると動かせてownerに通知するだけ
	// 選択とか付加機能は子クラスでやる
	//
	private var dragging:Boolean;
	private var onmouse:Boolean;
	private var owner;
	private var dragStartPos:Point;
	
	function init(owner) {
		this.owner = owner;
		this.dragging = false;
		this.onmouse = false;
		update();
		return this;
	}
	private function update() {
		clear();
		var color = (onmouse) ? 0x00FFFF : 0xFFFFFF;
		drawHandle(color);
	}
	private function drawHandle(color) {
		drawFillRect(-4, -4, 8, 8,
					 1, 0x0000FF, 100,
					 color, 100);
	}
	
	public function getDistance():Point {
		return getPosition().subtract(dragStartPos);
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	public function getPosition():Point {
		return new Point(_x, _y);
	}
	public function setScale(value:Number):Void {
		_xscale = value;
		_yscale = value;
	}
	
	private function getMousePos():Point {
		return new Point(owner._xmouse, owner._ymouse);
	}
	
	//
	// マウスイベント
	//
	function onPress() {
		if (dragging == false) {
			dragStartPos = getPosition();
			dragging = true;
			owner.onHandlePress(this);
		}
	}
	private function moveToNewPos(newPos):Void {
		_x = newPos.x;
		_y = newPos.y;
	}
	function onMouseMove() {
		if (dragging) {
			var newPos = getMousePos();
			if (Point.distance(dragStartPos, newPos) > 5) {
				moveToNewPos(newPos);
			} else {
				_x = dragStartPos.x;
				_y = dragStartPos.y;
			}
			owner.onHandleDrag(this);
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if (dragging) {
			onMouseMove();
			dragging = false;
			owner.onHandleStopDrag(this);
			
			// off highlight
			onmouse = false;
			update();
		}
	}
	function onRollOver() {
		onmouse = true;
		update();
	}
	function onRollOut() {
		onmouse = false;
		update();
	}
}