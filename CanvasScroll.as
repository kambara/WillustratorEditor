import mx.controls.*;
import util.*;
import flash.geom.*;

class CanvasScroll extends mx.core.UIObject {
	private var main:Main; // initObj
	private var horizontalScroll:UIScrollBar;
	private var verticalScroll:UIScrollBar;
	
	function CanvasScroll() {
	}
	function createChildren() {
		createObject("UIScrollBar", "horizontalScroll", 0);
		createObject("UIScrollBar", "verticalScroll", 1);
		
		horizontalScroll.horizontal = true;
		verticalScroll._xscale = -100;
		
		horizontalScroll.setScrollProperties(400, 0, 1600);
		verticalScroll.setScrollProperties(400, 0, 1600);
		
		horizontalScroll.addEventListener("scroll", this);
		verticalScroll.addEventListener("scroll", this);
		
		var lssize = 20;
		horizontalScroll.lineScrollSize = lssize;
		verticalScroll.lineScrollSize = lssize;
		
		Stage.addListener(this);
		onResize();
		
		invalidate();
	}
	public function getPosition():Point {
		return new Point(horizontalScroll.scrollPosition, verticalScroll.scrollPosition);
	}
	function onResize() {
		horizontalScroll.setSize(Stage.width-64, 15);
		horizontalScroll.move(StagePosition.getLeft() + 65,
									StagePosition.getBottom() - 15);
		
		horizontalScroll.setScrollProperties(horizontalScroll._width, 0, 1600);
		horizontalScroll.pageScrollSize = 50;
		
		verticalScroll.setSize(15, Stage.height-56);
		verticalScroll.move(StagePosition.getLeft()+15,
									StagePosition.getTop() + 39);
		verticalScroll.setScrollProperties(verticalScroll._height, 0, 1600);
		verticalScroll.pageScrollSize = 50;
	}
	function scroll() {
		main.onScroll();
		//trace("x:" +horizontalScroll.scrollPosition);
		//trace("y:"+verticalScroll.scrollPosition);
	}
}