import util.*;

class property.PropertyPanel extends mx.core.UIComponent {
	// initObject
	private var main;
	private var shapeModel;
	
	//private var focused:Boolean;
	//private var backgroundPanel;
	
	function PropertyPanel() {
	}
	public function setup(m, model):Void {
		main = m;
		shapeModel = model;
	}
	public function init():Void {
		super.init();
		/*
		this.focused = false;
		attachMovie("AdvancedDrawingMC", "backgroundPanel", -10);
		var self = this;
		backgroundPanel.useHandCursor = false;
		backgroundPanel.onPress = function() {
		};
		Stage.addListener(this);
		onResize();
		*/
	}
	public function draw():Void {
		super.draw();
	}
	public function isFocused():Boolean {
		//return focused;
		return false;
	}
	public function onResize() {
		//drawBackground();
		/*
		setPosition(StagePosition.getRight() - _width,
						StagePosition.getTop() + 40);
		*/
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	private function drawBackground() {
		/*
		backgroundPanel.clear();
		backgroundPanel.drawFillRect(0, 0, 200, Stage.height,
					 1, 0xCCCCCC, 100,
					 0xDDDDDD, 100);
		*/
	}
}
