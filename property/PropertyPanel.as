import util.*;

class property.PropertyPanel extends mx.core.UIObject {
	
	static var symbolName:String = "property.PropertyPanel";
	static var symbolOwner:Object = Object(property.PropertyPanel);
	var className:String = "PropertyPanel";
	
	// initObject
	private var main;
	private var shapeModel;
	
	private var focused:Boolean;
	private var backgroundPanel;
	
	function PropertyPanel() {
	}
	public function init():Void {
		super.init();
		this.focused = false;
		
		attachMovie("AdvancedDrawingMC", "backgroundPanel", -10);
		var self = this;
		backgroundPanel.useHandCursor = false;
		backgroundPanel.onPress = function() {
		};
		
		Stage.addListener(this);
		onResize();
	}
	public function draw():Void {
		super.draw();
	}
	public function isFocused():Boolean {
		return focused;
	}
	public function onResize() {
		drawBackground();
		setPosition(StagePosition.getRight() - _width,
						StagePosition.getTop() + 40);
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	private function drawBackground() {
		backgroundPanel.clear();
		backgroundPanel.drawFillRect(0, 0, 200, Stage.height,
					 1, 0xCCCCCC, 100,
					 0xDDDDDD, 100);
	}
}
