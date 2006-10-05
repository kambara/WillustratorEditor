import util.*;
import canvas.edit.handle.*;

class canvas.edit.handle.HandleX extends Handle {
	var dragStartX:Number;
	var dragStartMouseX:Number;
	function onPress() {
		dragStartX = _x;
		dragStartMouseX = owner._xmouse;
		dragging = true;
		owner.onHandlePress();
	}
	function onMouseMove() {
		if (dragging) {
			////_x = dragStartX + (owner._xmouse - dragStartMouseX);
			////var newPos = getSnapedPos();
			var newPos = getMousePos();
			_x = newPos.x;
			owner.onHandleDrag(_name, newPos.x, _y);
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if (dragging) {
			dragging = false;
			/////_x = dragStartX + (owner._xmouse - dragStartMouseX);
			////var newPos = getSnapedPos();
			var newPos = getMousePos();
			_x = newPos.x;
			owner.onHandleStopDrag(_name, newPos.x, _y);
		}
	}
}