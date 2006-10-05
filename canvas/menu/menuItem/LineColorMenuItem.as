import canvas.menu.menuItem.*;

class canvas.menu.menuItem.LineColorMenuItem extends MenuItem {
	private var lineColor:Number = 0x000000;
	private var menu;
	
	public function init(menu, pos, color) {
		this.menu = menu;
		this.lineColor = color;
		setPosition(pos);
		draw();
	}
	private function draw() {
		drawFillRect(0, 0,
					 30, 30,
					 1, 0xFFFFFF, 100,
					 0xFFFFFF, 100);
		drawStyleLine(20, 8,
					  8, 20,
					  3, lineColor, 100);
	}
	function onRelease() {
		menu.setLineColor(this.lineColor);
	}
}
