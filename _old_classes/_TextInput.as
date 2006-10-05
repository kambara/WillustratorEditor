import util.*;

class util.TextInput extends MovieClip {
	private var textfield:TextField;
	
	public function init(x, y):Void {
		createTextField("textfield", 0, 0, 0, 40, 20);
		textfield.type = "input";
		textfield.background = true;
		
		var textformat = new TextFormat();
		textformat.align = "left";
		textformat.size = 14;
		textformat.font = "_sans";
		textfield.setNewTextFormat(textformat);
		
		this._x = x;
		this._y = y;
		
		var self = this;
		textfield.onSetFocus = function() {
			Key.addListener(self);
			self.onSetFocus();
		}
		textfield.onKillFocus = function() {
			Key.removeListener(self);
			self.onKillFocus();
		}
	}
	function onKillFocus() {
	}
	function onSetFocus() {
	}
	function onEnter() {
	}
	function onKeyDown() {
		if (Key.isDown(Key.ENTER)) {
			onEnter();
		}
	}

	public function setText(text:String):Void {
		textfield.text = (text) ? text: "";
	}
	public function getText():String {
		return textfield.text;
	}
}