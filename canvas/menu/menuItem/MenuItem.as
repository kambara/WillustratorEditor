import util.*;

class canvas.menu.menuItem.MenuItem extends AdvancedDrawingMC {
	private var owner;
	
	public function init(owner, pos) {
		this.owner = owner;
		setup();
		if (pos) setPosition(pos);
	}
	public function setup() { // Abstract
	}
	public function setPosition(pos) {
		this._x = pos.x;
		this._y = pos.y;
	}
	function onRollOver() {
		// 枠か背景変更
	}
	function onRelease() {
		owner.onIconClick(this._name);
	}
	
	public function getBottom() {
		return (this._y + this._height);
	}
	public function getRight() {
		return (this._x + this._width);
	}
}