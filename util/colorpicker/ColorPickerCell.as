import util.*;

class util.colorpicker.ColorPickerCell extends AdvancedDrawingMC {
	private var color:Number;
	private var cellw:Number = 10;
	private var picker;
	
	function init(c, x, y, cellw, pi) {
		this.color = c;
		_x = x;
		_y = y;
		this.cellw = cellw;
		this.picker = pi;
		draw(false);
	}
	function draw(mouseover) {
		clear();
		var lineColor = mouseover ? 0xFFFFFF : 0x000000;
		drawFillRect(0, 0, cellw, cellw,
					 1, lineColor, 100,
					 this.color, 100);
	}
	function onRelease() {
		picker.onPick(this.color);
	}
	function onRollOver() {
		draw(true);
		this.swapDepths(_parent.getNextHighestDepth());
	}
	function onRollOut() {
		draw(false);
	}
}