import util.*;
import model.*;
import canvas.shape.*;
import flash.geom.*;

class canvas.shape.Box extends Shape {
	var textlabel:TextLabel;
	
	function Box() {
		attachMovie("TextLabel", "textlabel", 0).init();
	}
	function draw():Void {
		clear();
		if (shapeModel.figure == "rect")
			drawBoxRect();
		else if (shapeModel.figure == "ellipse")
			drawBoxEllipse();
		drawText();
	}
	private function drawWhileDragging(d:Point):Void {
		draggingFrame.clear();
		draggingFrame.drawRectLine(shapeModel.x+d.x, shapeModel.y+d.y, shapeModel.width, shapeModel.height,
												1, 0x000000, 100);
	}
	private function drawBoxRect() {
		if (shapeModel.style.getFillAlpha()>0 || shapeModel.style.fill != null) {
			drawFillRoundRect(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 shapeModel.style.strokeWidth, shapeModel.style.stroke,
									 shapeModel.style.getStrokeAlpha(),
									 shapeModel.style.fill,
									 shapeModel.style.getFillAlpha());
		} else {
			drawRoundRectLine(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 10, 0x000000, 0);
			drawRoundRectLine(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 shapeModel.style.strokeWidth, shapeModel.style.stroke,
									 shapeModel.style.getStrokeAlpha());
		}
	}
	private function drawBoxEllipse() {
		var rx = shapeModel.width/2;
		var ry = shapeModel.height/2;
		var cx = shapeModel.x + rx;
		var cy = shapeModel.y + ry;
		if (shapeModel.style.getFillAlpha() > 0 || shapeModel.style.fill != null) {
			drawFillOval(cx, cy, rx, ry,
						 shapeModel.style.strokeWidth,
						 shapeModel.style.stroke,
						 shapeModel.style.getStrokeAlpha(),
						 shapeModel.style.fill,
						 shapeModel.style.getFillAlpha());
		} else {
			drawOvalLine(cx, cy, rx, ry,
						 10, 0x000000, 0);
			drawOvalLine(cx, cy, rx, ry,
						 shapeModel.style.strokeWidth,
						 shapeModel.style.strokeColor,
						 shapeModel.style.getStrokeAlpha());
		}
	}
	private function drawText() {
		textlabel.setProperties(shapeModel.text,
							shapeModel.x + shapeModel.width/2,
							shapeModel.y + shapeModel.height/2,
							shapeModel.textstyle.color,
							shapeModel.textstyle.fontSize,
							"center", "middle");
	}
	
	/***
	function hitTo(target:MovieClip) {
		var a = new Point(shapeModel.center.x, shapeModel.center.y);
		var b = new Point(shapeModel.center.x + shapeModel.radius.width,
						  shapeModel.center.y);
		var c = new Point(shapeModel.center.x - shapeModel.radius.width,
						  shapeModel.center.y);
		var d = new Point(shapeModel.center.x,
						  shapeModel.center.y + shapeModel.radius.height);
		var e = new Point(shapeModel.center.x,
						  shapeModel.center.y - shapeModel.radius.height);
		return ( target.hitTest(a.x, a.y, true)
					|| target.hitTest(b.x, b.y, true)
					|| target.hitTest(c.x, c.y, true)
					|| target.hitTest(d.x, d.y, true)
					|| target.hitTest(e.x, e.y, true) );
	}
	***/
}