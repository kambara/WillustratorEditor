import canvas.menu.menuItem.*;

class canvas.menu.menuItem.FillColorMenuItem extends MenuItem {
	private var fillColor:Number = 0x000000;
	private var menu;
	
	public function init(menu, pos, color) {
		this.menu = menu;
		this.fillColor = color;
		setPosition(pos);
		draw();
	}
	private function draw() {
		drawFillRect(0, 0,
					 30, 30,
					 1, 0xFFFFFF, 100,
					 0xFFFFFF, 100);
		drawFillRect(
					 5, 5,
					 20, 20,
					 1, 0x000000, 100,
					 fillColor, 100);
	}
	function onRelease() {
		menu.setFillColor(this.fillColor);
	}
}
