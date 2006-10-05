import util.*;
import model.*;
import canvas.shape.*;

class canvas.shape.Circle extends Shape {
	var textfield:TextField;
	
	function Circle() {
		createTextField("textfield", 1, 0, 0, 1, 1);
		textfield.autoSize = true;
		textfield.selectable = false;
		textfield.multiline = true;
	}
	function draw():Void {
		clear();
		lineStyle(model.lineWidth, model.lineColor, 100);
		beginFill(model.fillColor, 50);
		drawOval(
				 model.center.x, model.center.y,
				 model.radius.width, model.radius.height);
		endFill();
		if (model.text) {
			drawText();
		}
	}
	function drawText() {
		var textformat = new TextFormat();
		textformat.align = "center";
		textformat.size = model.fontSize;
		textformat.font = "_sans";
		textfield.setNewTextFormat(textformat);
		textfield.textColor = model.color;
		if (textfield.text != model.text) {
			textfield.text = model.text;
		}
		textfield._x = model.center.x - textfield._width/2;
		textfield._y = model.center.y - textfield._height/2;
		
	}
	function hitTo(target:MovieClip) {
		var a = new Point(model.center.x, model.center.y);
		var b = new Point(model.center.x + model.radius.width,
						  model.center.y);
		var c = new Point(model.center.x - model.radius.width,
						  model.center.y);
		var d = new Point(model.center.x,
						  model.center.y + model.radius.height);
		var e = new Point(model.center.x,
						  model.center.y - model.radius.height);
		return ( target.hitTest(a.x, a.y, true)
					|| target.hitTest(b.x, b.y, true)
					|| target.hitTest(c.x, c.y, true)
					|| target.hitTest(d.x, d.y, true)
					|| target.hitTest(e.x, e.y, true) );
	}
	function getLeftBottom() {
		var left = model.center.x - model.radius.width;
		var bottom = model.center.y + model.radius.height;
		return new Point(left, bottom);
	}
}