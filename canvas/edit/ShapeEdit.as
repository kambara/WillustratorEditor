import util.*;
import canvas.*;
import flash.geom.*;

class canvas.edit.ShapeEdit extends WillustratorDrawingMC {
	private var shapeModel;
	private var main:Main;
	private var editLayer;

	public function init(m, main, editLayer) {
		this.shapeModel = m;
		this.main = main;
		this.editLayer = editLayer;
		this.update();
		Key.addListener(this);
	}
	function update() { // Abstract
	}
	public function isSnapping() {
		return main.getDocument().isSnapping();
	}
	public function getCanvasScale() {
		return main.getCanvasScale();
	}
	public function changeEditType(type:String) { // Abstract
	}
	function onKeyDown() {
		if (main.isPropertyFocused())
			return;
		switch(Key.getCode()) {
			case Key.DELETEKEY:
			case Key.BACKSPACE:
				main.removeSelectedShapes();
				break;
			case Key.UP:
				main.moveSelectedShapes(new Point(0, -1));
				break;
			case Key.DOWN:
				main.moveSelectedShapes(new Point(0, 1));
				break;
			case Key.LEFT:
				main.moveSelectedShapes(new Point(-1, 0));
				break;
			case Key.RIGHT:
				main.moveSelectedShapes(new Point(1, 0));
				break;
		}
	}
}
