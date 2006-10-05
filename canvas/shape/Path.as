import util.*;
import model.*;
import canvas.shape.*;
import flash.geom.*;

class canvas.shape.Path extends Shape {
	var textlabel:TextLabel;
	
	function Path() {
		attachMovie("TextLabel", "textlabel", 0).init();
	}
	function draw():Void {
		clear();
		if (shapeModel.vertices.getLength()<2) {
			return;
		}
		drawPath();
		drawText();
	}
	private function drawPath() {
		// fill
		if (shapeModel.style.getFillAlpha()>0 || shapeModel.style.fill != null) {
			drawFillPath(shapeModel.vertices,
							0, 0x000000, 0,
							shapeModel.style.fill,
							shapeModel.style.getFillAlpha(),
							shapeModel.closepath);
		}
		
		// arrow
		/*
		if (shapeModel.startarrow == "triangle") {
			var h = 40;
			var w = 20;
			var color = shapeModel.style.stroke;
			
			lineStyle(1, color, 100);
			beginFill(color, 100);
			moveTo(0, 0);
			lineTo(w/2, h);
			lineTo(-w/2, h);
			lineTo(0, 0);
			endFill();
		}
		*/
		
		// stroke
		if (shapeModel.style.getStrokeAlpha()>0 || shapeModel.style.stroke != null) {
			drawPathLine(shapeModel.vertices,
							10, 0x000000, 0,
							shapeModel.closepath);
			drawPathLine(shapeModel.vertices,
								shapeModel.style.strokeWidth,
								shapeModel.style.stroke,
								shapeModel.style.getStrokeAlpha(),
								shapeModel.closepath);
		}
	}
	private function drawWhileDragging(d:Point):Void {
		draggingFrame.clear();
		var v = shapeModel.vertices.clone();
		v.move(d);
		draggingFrame.drawPathLine(v, 1, 0x000000, 100, shapeModel.closepath);
	}
	private function drawText() {
		var center:Point = shapeModel.getCenterPoint();
		textlabel.setProperties(shapeModel.text,
							center.x,
							center.y,
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
	function getLeftBottom() { // 廃止
		var left = shapeModel.center.x - shapeModel.radius.width;
		var bottom = shapeModel.center.y + shapeModel.radius.height;
		return new Point(left, bottom);
	}
	***/
}