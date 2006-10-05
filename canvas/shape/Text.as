import util.*;
import model.*;
import canvas.shape.*;
import flash.geom.*;

class canvas.shape.Text extends Shape {
	var textlabel:TextLabel;
	
	function Text() {
		attachMovie("TextLabel", "textlabel", 0).init();
	}
	function draw():Void {
		textlabel.setProperties(shapeModel.text,
							shapeModel.x, shapeModel.y,
							shapeModel.textstyle.color,
							shapeModel.textstyle.fontSize,
							"left", "top");
	}
	private function drawWhileDragging(d:Point):Void {
		draggingFrame.clear();
		draggingFrame.drawRectLine(shapeModel.x+d.x+2, shapeModel.y+d.y,
											   _width-4, _height,
												1, 0x000000, 100);
	}
	
	function hitTo(target:MovieClip) {
		var a = new Point(shapeModel.position.x, shapeModel.position.y);
		var b = new Point(shapeModel.position.x + _width,
						  shapeModel.position.y);
		var c = new Point(shapeModel.position.x,
						  shapeModel.position.y + _height);
		var d = new Point(shapeModel.position.x + _width,
						  shapeModel.position.y + _height);
		return ( target.hitTest(a.x, a.y, true)
					|| target.hitTest(b.x, b.y, true)
					|| target.hitTest(c.x, c.y, true)
					|| target.hitTest(d.x, d.y, true) );
	}
	/*
	function getLeftBottom() {
		var left = shapeModel.position.x;
		var bottom = shapeModel.position.y + _height;
		return new Point(left, bottom);
	}
	*/
}