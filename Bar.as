import util.*;
import tools.*;

class Bar extends AdvancedDrawingUIObject {
	var main:Main;
	
	var saveButton:Save;
	var toolButtons:ToolButtons;
	
	function Bar() { // want main
	}
	function init() {
		super.init();
	}
	function createChildren() {
		attachMovie("ToolButtons", "toolButtons", 0).init(main);
		toolButtons.setPosition(15, 5);
		attachMovie("Save", "saveButton", 1).init(main.getDocument(), main.getSaveUrl());
		saveButton.setPosition(230, 10);
		
		Stage.addListener(this);
		onResize();
		
		invalidate();
	}
	function draw() {
		super.draw();
		drawBackground();
		setPosition(StagePosition.getLeft(),
						StagePosition.getTop());
	}
	public function onResize() {
		invalidate();
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	public function updateToolButtons() {
		toolButtons.update();
	}
	
	private function drawBackground() {
		clear();
		var h = 40;
		drawFillRect(0, 0, Stage.width, h, {
			lineColor: 0xFFFFFF
		});
		drawStyleLine(0, h, Stage.width, h, {
			lineColor: 0xCCCCCC
		});
	}
}