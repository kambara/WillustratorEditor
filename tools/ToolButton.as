import util.*;

class tools.ToolButton extends AdvancedDrawingMC {
	private var main;
	
	public function init(m) {
		this.main = m;
		gotoAndStop(1);
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	public function update() {
		if (main.getCurrentTool() == getToolType()) {
			select();
		} else {
			unselect();
		}
	}
	private function getToolType() {
	}
	public function select() {
		gotoAndStop(2);
	}
	public function unselect() {
		gotoAndStop(1);
	}
	private function onClick() {
	}
	function onPress() {
		if (main.getCurrentTool() != this.getToolType()) {
			main.onToolSelected(this.getToolType());
		}
	}
}
