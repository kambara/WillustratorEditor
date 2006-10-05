import util.*;
import canvas.*;

class Pan extends AdvancedDrawingMC {
	private var canvas:Canvas;
	private var dragging:Boolean;
	private var dragStartPos:Point;
	
	public function init(c) {
		canvas = c;
		dragging = false;
		draw();
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	public function onPress() {
		
		dragging = true;
		dragStartPos = new Point(_xmouse, _ymouse);
		canvas.moveStart();
		Mouse.hide();
	}
	public function onMouseMove() {
		if (dragging) {
			var currentPos = new Point(_xmouse, _ymouse);
			canvas.move(new Distance(dragStartPos, currentPos));
			updateAfterEvent();
		}
	}
	public function onMouseUp() {
		dragging = false;
		Mouse.show();
	}
	private function draw() {
		clear();
		drawFillRect(0, 0, 20, 20,
					 1, 0x000000, 0,
					 0x000000, 0);
		
		lineStyle(1, 0xCCCCCC, 100);
		drawLine(0, 10, 20, 10);
		drawLine(10, 0, 10, 20);
		
		lineStyle(1, 0x666666, 100);
		drawRect(0, 0, 20, 20);
	}
}