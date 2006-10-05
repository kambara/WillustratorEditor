import util.*;
import tools.*;
import canvas.layer.*;
import canvas.creator.*;

class canvas.layer.CreateShapeLayer extends Layer {
	private var shapeCreator;
	
	public function startCreate() {
		finishCreate();
		var tool:String = main.getCurrentTool();
		if (tool != ToolType.select) {
			attachMovie(tool+"Creator", "shapeCreator", 0).init(main, this);
		}
	}
	public function finishCreate() {
		if (shapeCreator) {
			shapeCreator.removeMovieClip();
		}
	}
	public function onAnotherToolSelected() {
		if (shapeCreator) {
			shapeCreator.onAnotherToolSelected();
		}
	}
}
