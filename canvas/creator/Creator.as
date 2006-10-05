import canvas.*;
import util.*;
import canvas.layer.*;
import flash.geom.*;

class canvas.creator.Creator extends WillustratorDrawingMC {
	private var main;
	private var createShapeLayer:CreateShapeLayer;
	private var panel:AdvancedDrawingMC;
	
	public function init(m, layer) {
		this.main = m;
		this.createShapeLayer = layer;
		drawPanel();
		useHandCursor = false;
	}
	private function drawPanel() {
		attachMovie("AdvancedDrawingMC", "panel", 0);
		panel.drawFillRect(-100, -100,
					 Stage.width+200, Stage.height+200,
					 1, 0xFFFFFF, 0,
					 0xFFFFFF, 0);
	}
	public function onAnotherToolSelected() {
	}
}