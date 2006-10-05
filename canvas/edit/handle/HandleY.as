import util.*;
import canvas.edit.handle.*;

class canvas.edit.handle.HandleY extends Handle {
	var dragStartY:Number;
	var dragStartMouseY:Number;
	function onPress() {
		dragStartY = _y;
		dragStartMouseY = owner._ymouse;
		dragging = true;
		owner.onHandlePress();
	}
	function onMouseMove() {
		if (dragging) {
			////var newPos = getSnapedPos();
			var newPos = getMousePos();
			_y = newPos.y
			owner.onHandleDrag(_name, _x, newPos.y);
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if (dragging) {
			dragging = false;
			////var newPos = getSnapedPos();
			var newPos = getMousePos();
			_y = newPos.y;
			owner.onHandleStopDrag(_name, _x, newPos.y);
		}
	}
}