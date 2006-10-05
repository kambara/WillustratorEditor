import util.*;
import canvas.creator.*;

class canvas.creator.TextCreator extends Creator {
	var textLabel:EditableTextLabel;
	var editing:Boolean = false;
	var x:Number = 0;
	var y:Number = 0;
	
	function onPress() {
		editing = true;
	}
	function onKillFocus() {
		if (editing) {
			editing = false;
			main.createText(textLabel.getText(), x, y);
			this._visible = false;
		}
	}
	function onMouseUp() {
		if (editing) {
			attachMovie("EditableTextLabel", "textLabel", 0).init(this);
			var pos = createShapeLayer.getCurrentMousePos();
			x = pos.x;
			y = pos.y;
			textLabel.setProperties("", pos.x, pos.y, 0x000000, 20, "left", "top");
			var self = this;
			textLabel.onKillFocus = function() {
				self.onKillFocus();
			}
		}
	}
}