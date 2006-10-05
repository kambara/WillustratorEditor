import util.*;

class canvas.shape.Arrow extends MovieClip {
	private var color;
	
	public function init() {
		angle = 0;
		color = 0x000000;
	}
	public function setAngle(value) {
		this._rotation = value;
		draw();
	}
	public function setColor(c) {
		color = c;
		draw();
	}
	private function draw() {
		var h = 40;
		var w = 20;
		
		lineStyle(1, color, 100);
		beginFill(color, 100);
		moveTo(0, 0);
		lineTo(w/2, h);
		lineTo(-w/2, h);
		lineTo(0, 0);
		endFill();
	}
}