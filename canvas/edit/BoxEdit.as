import util.*;
import canvas.*;
import canvas.edit.*;
import canvas.edit.handle.*;
import flash.geom.*;

class canvas.edit.BoxEdit extends ShapeEdit {
	private var sizer:Sizer;

	public function update():Void {
		createChildren();
		draw();
	}
	private function createChildren():Void {
		if (sizer)
			sizer.removeMovieClip();
		attachMovie("Sizer", "sizer", 0).init(this);
	}
	private function draw():Void {
		sizer.setRectangle(new Rectangle(
			shapeModel.x,
			shapeModel.y,
			shapeModel.width,
			shapeModel.height
		));
	}
	public function onSizerChanged(rect:Rectangle) {
		shapeModel.x = Math.min(rect.left, rect.right);
		shapeModel.y = Math.min(rect.top, rect.bottom);
		shapeModel.width = Math.abs(rect.width);
		shapeModel.height = Math.abs(rect.height);
		main.onEditChanged();
	}
}