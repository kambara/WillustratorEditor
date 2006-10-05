class util.TextLabel extends MovieClip {
	private var textfield:TextField;
	private var x:Number;
	private var y:Number;
	private var align:String;
	private var valign:String;
	
	public function init():TextLabel {
		createTextField("textfield", 1, 0, 0, 1, 1);
		textfield.autoSize = true;
		textfield.selectable = false;
		textfield.multiline = true;
		return this;
	}
	
	public function setProperties(text, x, y, color, fontSize, align, valign) {
		this.align = align ? align : "left";
		this.valign = valign ? valign : "top";
		
		var textformat = new TextFormat();
		textformat.align = this.align;
		textformat.size = fontSize;
		textformat.font = "_sans";
		textfield.setNewTextFormat(textformat);
		textfield.textColor = color;
		textfield.text = (text) ? text : "";
		
		this.x = x;
		this.y = y;
		
		adjust();
	}
	private function adjust() {
		if (align == "center") {
			_x = x - this._width/2;
		} else { // left
			_x = x;
		}
		if (valign == "middle") {
			_y = y - this._height/2;
		} else { // top
			_y = y;
		}
	}
}