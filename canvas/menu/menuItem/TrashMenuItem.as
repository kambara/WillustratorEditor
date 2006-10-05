import canvas.menu.menuItem.*;

class canvas.menu.menuItem.TrashMenuItem extends MenuItem {
	private var menu;
	
	public function init(menu, pos, color) {
		this.menu = menu;
		setPosition(pos);
	}
	function onRelease() {
		menu.remove();
	}
}
