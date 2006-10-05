import util.*;
import canvas.*;
import flash.geom.*;

class canvas.menu.Menu extends AdvancedDrawingMC {
	var canvas:Canvas;
	var model;
	
	public function init(c:Canvas, m, pos:Point) {
		this.canvas = c;
		this.model = m;
		this._x = pos.x;
		this._y = pos.y;
		setup();
		correctPosition();
		drawFrame();
	}
	private function setup() { // Abstract
	}
	private function drawFrame() {
		drawFillRect(
					 -1, -1,
					 this._width+2, this._height+2,
					 1, 0x999999, 100,
					 0xFFFFFF, 100);
		
		// 大き目の透明パネル
		drawFillRect(
					 -5, -5,
					 this._width+10, this._height+10,
					 1, 0x000000, 0,
					 0x000000, 0);
		
	}
	
	public function remove() {
		canvas.removeSelectedShape();
	}
	
	private function correctPosition() { // 位置補正
		if (_y+_height > StagePosition.getBottom()-30) {
			//_root.info.text = StagePosition.getTop()+" "+Stage.height;
			_y = StagePosition.getBottom()-30-_height;
			_x -= _width+10;
		}
	}
	//
	// model更新
	//
	/*
	function setLineWidthNarrow() {
		model.lineWidth = 1;
		canvas.update();
		canvas.defaultLineWidth = 1;
	}
	function setLineWidthWide() {
		model.lineWidth = 5;
		canvas.update();
		canvas.defaultLineWidth = 5;
	}
	
	function setFontSizeBig() {
		model.fontSize = 30;
		canvas.onSelectMenu();
	}
	function setFontSizeMiddle() {
		model.fontSize = 20;
		canvas.onSelectMenu();
	}
	function setFontSizeSmall() {
		model.fontSize = 14;
		canvas.onSelectMenu();
	}
	function setArrowBoth() {
		model.arrow = "both";
		canvas.update();
	}
	function setArrowStart() {
		model.arrow = "start";
		canvas.update();
	}
	function setArrowEnd() {
		model.arrow = "end";
		canvas.update();
	}
	function setArrowNone() {
		model.arrow = "none";
		canvas.update();
	}
	
	function setLineColor(color) {
		model.lineColor = color;
		canvas.update();
	}
	function setFillColor(color) {
		model.fillColor = color;
		canvas.update();
	}
	function setTextColor(color) {
		model.color = color;
		canvas.update();
	}
	*/
}
