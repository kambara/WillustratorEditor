import util.*;
import canvas.*;

class canvas.VerticalSizer extends Sizer {
	private function draw() {
		clear();
		drawStyleLine(0, 0, 0, length, 8, 0x0000FF, 0);
		drawStyleLine(0, 0, 0, length, 1, 0x0000FF, 50);
	}
	private function getValue() {
		return _x;
	}
	private function onDrag() {
		_x = _parent._xmouse;
	}
}