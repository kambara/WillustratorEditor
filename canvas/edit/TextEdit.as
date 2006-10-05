import util.*;
import canvas.*;
import canvas.edit.*;

class canvas.edit.TextEdit extends ShapeEdit {
	var textfield:TextField;
	var panel;
	
	private function update():Void {
		clear();
		drawFrame();
	}
	private function drawFrame() {
		drawRectLine(
				 shapeModel.x, shapeModel.y,
				 shapeModel.getRight() - shapeModel.x,
				 shapeModel.getBottom() - shapeModel.y,
				 1, 0x0000FF, 30);
	}
}
