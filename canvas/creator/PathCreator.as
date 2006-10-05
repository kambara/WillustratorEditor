import util.*;
import canvas.creator.*;
import model.*;
import flash.geom.*;

class canvas.creator.PathCreator extends Creator {
	private var vertices:Vertices;
	private var dragging:Boolean = false;
	private var startAnchorDrag:Boolean = false;
	private var dragStartPos:Point;
	
	private function drawAnchor(anchor:Point) {
		moveTo(anchor.x, anchor.y); // なぜかこれが必要
		
		var handleScale = 100/main.getCanvasScale();
		var w = 8 * handleScale;
		drawFillRect(anchor.x-w/2, anchor.y-w/2, w, w,
					 0, 0x0000FF, 100,
					 0xFFFFFF, 100);
	}
	private function drawHandle(p1, p2) {
		drawStyleLine(p1.x, p1.y, p2.x, p2.y, 
						  1, 0x0000FF, 100);
	}
	private function drawSymmetryHandle(p1:Point, p2:Point) {
		var d:Point = p2.subtract(p1);
		drawStyleLine(p1.x-d.x, p1.y-d.y, p2.x, p2.y, 
						  1, 0x0000FF, 100);
	}
	private function draw() {
		clear();
		if (startAnchorDrag) {
			var anchor = vertices.getItemAt(0).getAnchor();
			var pos = createShapeLayer.getCurrentMousePos();
			drawSymmetryHandle(anchor, pos);
		}
		if (dragging) {
			var pos = createShapeLayer.getCurrentMousePos();
			if (vertices.getLength() == 0) {
				drawHandle(dragStartPos, pos);
			} else {
				drawSymmetryHandle(dragStartPos, pos);
			}
			drawAnchor(dragStartPos);
		}
		if (vertices.getLength() >= 1) {
			var v = vertices.getLastItem();
			if (v.getControlA().exist()) {
				drawHandle(v.getAnchor(), v.getControlA().getPoint());
			}
			if (v.getControlB().exist()) {
				drawHandle(v.getAnchor(), v.getControlB().getPoint());
			}
			if (vertices.getLength() >= 2) {
				drawPathLine(vertices, 1, 0x0000FF, 100, false);
				drawAnchor(vertices.getLastItem().getAnchor());
			}
			drawAnchor(vertices.getItemAt(0).getAnchor());
		}
	}
	
	private function hitTestAnchor(anchor:Point) {
		var pos:Point = createShapeLayer.getCurrentMousePos();
		return (pos.x <= anchor.x+5
				&& pos.x >= anchor.x-5
				&& pos.y <= anchor.y+5
				&& pos.y >= anchor.y-5);
	}
	private function hitTestStartAnchor() {
		var anchor:Point = vertices.getItemAt(0).getAnchor();
		return hitTestAnchor(anchor);
	}
	private function hitTestEndAnchor() {
		var anchor:Point = vertices.getLastItem().getAnchor();
		return hitTestAnchor(anchor);
	}
	
	public function onAnotherToolSelected() {
		main.createPath(vertices, false);
	}
	
	//
	// MouseEvent
	//
	function onPress() {
		if ( !vertices ) {
			vertices = new Vertices();
		} else if (hitTestStartAnchor()) {
			dragging = false;
			startAnchorDrag = true;
			return;
		} else if (hitTestEndAnchor()) {
			// 開いた線
			dragging = false;
			main.createPath(vertices, false);
			return;
		}
		dragStartPos = createShapeLayer.getCurrentMousePos();
		dragging = true;
	}
	function onMouseMove() {
		if (dragging || startAnchorDrag) {
			draw();
			updateAfterEvent();
		}
	}
	function onMouseUp() {
		if (startAnchorDrag) {
			// 閉じた線
			var v:Vertex = vertices.getItemAt(0);
			var pos:Point = createShapeLayer.getCurrentMousePos();
			var d:Point = pos.subtract(v.getAnchor());
			if (d.length > 5) {
				var ca:Control = new Control(new Point(
															   v.getAnchor().x - d.x,
															   v.getAnchor().y - d.y));
				v.setControlA(ca);
				v.setControlB(new Control(pos));
			}
			main.createPath(vertices, true);
			return;
		}
		if (dragging) {
			dragging = false;
			var pos:Point = createShapeLayer.getCurrentMousePos();
			var d:Point = pos.subtract(dragStartPos);
			if (d.length > 5) {
				var v:Vertex = new Vertex(dragStartPos);
				if (vertices.getLength() > 0) {
					var ca:Control = new Control(new Point(
																   dragStartPos.x - d.x,
																   dragStartPos.y - d.y));
					v.setControlA(ca);
				}
				v.setControlB(new Control(pos));
				vertices.addItem(v);
			} else {
				vertices.addItem(new Vertex(dragStartPos));
			}
			draw();
		}
	}
}