import util.*;
import canvas.creator.*;
import flash.geom.*;

class canvas.creator.BoxCreator extends Creator {
	var dragStartPos:Point;
	var dragging = false;
	
	function onPress() {
		this.dragStartPos = createShapeLayer.getCurrentMousePos();
		dragging = true;
	}
	function onMouseMove() {
		if (dragging) {
			clear();
			var pos =  createShapeLayer.getCurrentMousePos();
			drawRectLine(dragStartPos.x, dragStartPos.y,
						 pos.x - dragStartPos.x,
						 pos.y - dragStartPos.y,
								0, 0x0000FF, 100);
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if (dragging) {
			clear();
			var pos =  createShapeLayer.getCurrentMousePos();
			var d:Point = pos.subtract(dragStartPos);
			var x:Number = dragStartPos.x;
			var y:Number = dragStartPos.y;
			var w:Number = d.x;
			var h:Number = d.y;
			if (w < 0) {
				w = -w;
				x = x-w;
			}
			if (h < 0) {
				h = -h;
				y = y-h;
			}
			main.createBox(x, y, w, h, "rect");
		}
	}
}