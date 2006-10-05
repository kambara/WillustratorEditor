import util.*;
import model.*;
import canvas.layer.*;
import canvas.edit.*;
import flash.geom.*;

class canvas.layer.EditLayer extends Layer {
	private var shapeEdit:ShapeEdit;
	
	function draw() {
		super.draw();
		if (shapeEdit) {
			shapeEdit.update();
		}
	}
	public function startEdit() {
		finishEdit();
		var sc:ShapeCollection = main.getSelectedShapes();
		if (sc.getLength() == 1) {
			var m = sc.getItemAt(0);
			attachMovie(m.getShapeType()+"Edit", "shapeEdit", 0).init(m, main, this);
		} else if (sc.getLength() > 1) {
			attachMovie("MultiShapeEdit", "shapeEdit", 0).init(sc, main, this);
		}
	}
	public function finishEdit() {
		if (shapeEdit) {
			shapeEdit.removeMovieClip();
		}
	}
	public function changeEditType(type:String) {
		if (shapeEdit) {
			shapeEdit.changeEditType(type);
		}
	}
}