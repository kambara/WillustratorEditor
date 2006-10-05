import canvas.menu.menuItem.*;

class canvas.menu.menuItem.TextColorMenuItem extends MenuItem {
	private var textColor:Number = 0x000000;
	private var menu;
	private var textfield:TextField;
	
	public function init(menu, pos, color) {
		this.menu = menu;
		this.textColor = color;
		setupTextField();
		setPosition(pos);
		draw();
	}
	private function setupTextField() {
		createTextField("textfield", 0, 0, 0, 10, 10);
		textfield.autoSize = true;
		textfield.selectable = false;
		textfield._x = 7;
		textfield._y = 3;
		
		var textformat = new TextFormat();
		textformat.size = 18;
		textformat.color = textColor;
		textformat.font = "_sans";
		textfield.setNewTextFormat(textformat);
		
		textfield.text = "A";
	}
	private function draw() {
		var bgColor = 0xFFFFFF;
		if (textColor == 0xFFFFFF)
			bgColor = 0xCCCCCC;
		drawFillRect(0, 0,
					 30, 30,
					 1, 0xFFFFFF, 100,
					 bgColor, 100);
	}
	function onRelease() {
		menu.setTextColor(this.textColor);
	}
}
