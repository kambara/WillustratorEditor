import util.*;
import canvas.layer.*;
import flash.geom.*;

class canvas.layer.BackgroundLayer extends Layer {
	function BackgroundLayer() {
	}
	function init():Void {
		super.init();
		useHandCursor = false;
	}
	private function draw() {
		clear();
		var size = main.getDocument().getCanvasSize();
		// 枠の外
		/*
		var w = (Stage.width<100) ? 2000 : Stage.width+200; // for IE (最初のStage Sizeが取得できない)
		var h = (Stage.height<100) ? 2000 : Stage.height+200; // for IE
		*/
		var w = 3000;
		var h = 3000;
		drawFillRect(-100, -100, w, h, {
			fillColor: 0xEEEEEE,
			lineColor: 0xEEEEEE
		});

		// 影
		drawFillRect(2, 2, size.width, size.height, {
			fillColor: 0x999999,
			lineColor: 0x999999
		});

		// 枠
		drawFillRect(0, 0, size.width, size.height, {
			fillColor: main.getDocument().getCanvasColor(),
			lineColor: 0x000000,
			lineWidth: 0
		});

		// グリッド
		if (main.getDocument().isSnapping()) {
			drawGrid();
		}
	}
	private function drawGrid() {
		var size = main.getDocument().getCanvasSize();
		var gridInterval = 20;
		lineStyle(0, 0xCCCCCC, 100);
		
		// 縦線
		var col = size.width/gridInterval;
		for (var i=1; i<col; i++) {
			var x = i*gridInterval;
			drawLine(
					 x, 1,
					 x, size.height);
		}
		// 横線
		var row = size.height/gridInterval;
		for (var i=1; i<row; i++) {
			var y = i*gridInterval;
			drawLine(
					 1, y,
					 size.width, y);
		}
	}
	
	//
	// マウスイベント
	//
	//private var dragging:Boolean = false;
	private var dragStartMousePos:Point;
	function onPress() {
		////dragStartMousePos = getCurrentMousePos();
		////dragging = true;
		main.onBackgroundSelected(getCurrentMousePos());
	}
}