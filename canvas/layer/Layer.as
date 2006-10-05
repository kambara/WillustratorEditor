import util.*;
import flash.geom.*;

class canvas.layer.Layer extends AdvancedDrawingUIObject {
	private var main:Main; // initObj
	
	function init():Void {
		super.init();
	}
	public function getCurrentMousePos():Point {
		return new Point(_xmouse, _ymouse);
	}
}