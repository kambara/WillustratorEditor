import canvas.edit.handle.*;

class canvas.edit.handle.ControlHandle extends SelectableHandle {
	private var active:Boolean;
	
	public function init(owner) {
		active = false;
		super.init(owner);
	}
	public function getHandleType() {
		return "control";
	}
	private function update() {
		this._alpha = (active) ? 100 : 40;
		super.update();
	}
	private function drawHandle(color) {
		drawFillOval(0, 0, 3, 3,
					 1, 0x0000FF, 100,
					 color, 100);
	}
	public function activate() {
		active = true;
		update();
	}
	public function inactivate() {
		active = false;
		update();
	}
	public function show() {
		this._visible = true;
	}
	public function hide() {
		this._visible = false;
	}
}