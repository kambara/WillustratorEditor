import util.*;
import canvas.layer.*;
import flash.geom.*;

class canvas.layer.SelectionLayer extends Layer {
	private var startPoint:Point;
	private var dragging:Boolean;
	
	function SelectionLayer() {
	}
	function init():Void {
		super.init();
	}
	private function draw() {
		clear();
		var currentPoint = getCurrentMousePos();
		var d:Point = currentPoint.subtract(startPoint);

		drawFillRect(startPoint.x, startPoint.y, d.x, d.y, {
			fillColor: 0x0000FF,
			fillAlpha: 10,
			lineColor: 0x0000FF,
			lineWidth: 0
		});
	}
	public function startSelect(p:Point) {
		startPoint = p;
		dragging = true;
	}
	
	//
	// Mouse Event
	//
	function onMouseMove() {
		if (dragging) {
			draw();
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if ( !dragging ) return;
		dragging = false;
		var endPoint = getCurrentMousePos();
		var rect = new Rectangle(
			Math.min(startPoint.x, endPoint.x),
			Math.min(startPoint.y, endPoint.y),
			Math.abs(endPoint.x - startPoint.x),
			Math.abs(endPoint.y - startPoint.y)
		);
		main.selectShapesToIntersect(rect);
		clear();
	}
}