import util.*;

class util.EditableTextLabel extends TextLabel {
	public function init():Void {
		super.init();
		textfield.type = "input";
		textfield.selectable = true;
		textfield.border = true;
		textfield.background = true;
		var self = this;
		textfield.onChanged = function() {
			self.adjust();
			self.onChanged();
		}
		textfield.onKillFocus = function() {
			self.onKillFocus();
		}
		Selection.setFocus(textfield);
	}
	function onChanged() {
	}
	function onKillFocus() {
	}
	public function getText():String {
		return textfield.text;
	}
}