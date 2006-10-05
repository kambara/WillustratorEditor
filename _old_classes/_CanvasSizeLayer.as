import util.*;
import canvas.*;

class canvas.CanvasSizeLayer extends AdvancedDrawingMC {
	private var rightSizer:VerticalSizer;
	private var bottomSizer:HorizontalSizer;
	private var canvas:Canvas;
	
	public function init(c:Canvas) {
		this.canvas = c;
		attachMovie("VerticalSizer", "rightSizer", 1).init(this);
		attachMovie("HorizontalSizer", "bottomSizer", 2).init(this);
		update();
	}
	public function update() {
		// Sizer
		rightSizer._x = canvas.getSize().width;
		rightSizer.setLength(canvas.getSize().height);
		bottomSizer._y = canvas.getSize().height;
		bottomSizer.setLength(canvas.getSize().width);
	}
	public function onSizerStopDrag(name, value) {
		value = Math.round(value);
		switch(name) {
			case "rightSizer":
				canvas.setWidth(value);
				break;
			case "bottomSizer":
				canvas.setHeight(value);
				break;
		}
	}
}