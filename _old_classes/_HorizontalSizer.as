import util.*;
import canvas.*;

class canvas.HorizontalSizer extends Sizer {
	private function draw() {
		clear();
		drawStyleLine(0, 0, length, 0, 8, 0x0000FF, 0);
		drawStyleLine(0, 0, length, 0, 1, 0x0000FF, 50);
	}
	private function getValue() {
		return _y;
	}
	private function onDrag() {
		_y = _parent._ymouse;
	}
}
