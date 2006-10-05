class TrashMenuItem extends MovieClip {
	public function init() {
		
	}
	function createMenuItem(model) {
		var textformat = new TextFormat();
		textformat.size = model.fontSize;
		textformat.color = model.color;
		textformat.font = "_sans";
		textfield.setNewTextFormat(textformat);
		textfield._x = model.position.x;
		textfield._y = model.position.y;
		if (textfield.text != model.text) {
			textfield.text = model.text;
		}
	}
}