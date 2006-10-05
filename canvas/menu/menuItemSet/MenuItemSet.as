import util.*;
import flash.geom.*;

class canvas.menu.menuItemSet.MenuItemSet extends AdvancedDrawingMC {
	private var owner;
	
	public function init(owner, pos:Point) {
		this.owner = owner;
		this._x = pos.x;
		this._y = pos.y;
		setup();
	}
	private function setup() {
	}
	
	public function getBottom() {
		return (this._y + this._height);
	}
	public function getRight() {
		return (this._x + this._width);
	}
}