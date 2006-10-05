import util.*;
import canvas.*;
import canvas.menu.*;

class canvas.MenuLayer extends AdvancedDrawingMC {
	var canvas:Canvas;
	var contextMenu:Menu;
	
	function init(c:Canvas) {
		canvas = c;
	}
	public function show(model, pos:Point) {
		attachMovie(model.getShapeType()+"Menu", "contextMenu", 0).init(canvas, model, pos);
	}
	public function hide() {
		if (contextMenu) {
			contextMenu.removeMovieClip();
		}
	}
}