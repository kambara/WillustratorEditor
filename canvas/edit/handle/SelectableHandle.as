import canvas.edit.handle.*;

class canvas.edit.handle.SelectableHandle extends Handle {
	private var selected:Boolean;
	
	public function init(owner) {
		selected = false;
		super.init(owner);
	}
	public function getHandleType() {
		return "anchor";
	}
	private function update() {
		if (selected) {
			clear();
			drawHandle(0x0099FF);
		} else {
			super.update();
		}
	}
	public function select() {
		selected = true;
		update();
	}
	public function unselect() {
		selected = false;
		update();
	}
	public function toggle() {
		selected = !selected;
		update();
	}
	public function isSelected():Boolean {
		return selected;
	}
}