import util.*;
import model.*;
import canvas.edit.handle.*;
import flash.geom.*;

class canvas.edit.VertexHandles extends AdvancedDrawingMC {
	private var owner;
	private var index:Number;
	private var startOpen:Boolean;
	private var lastOpen:Boolean;
	private var anchorHandle;
	private var controlAHandle;
	private var controlBHandle;
	
	private var preVertex:Vertex;
	private var vertex:Vertex;
	private var nextVertex:Vertex;
	private var originalVertex:Vertex;
	
	private var oppositeHandleLength:Number; // スムーズアンカー用
	
	public function init(owner, p, v, n, i, startOpen, lastOpen) {
		this.owner = owner;
		preVertex = p;
		vertex = v;
		nextVertex = n;
		this.index = i;
		this.startOpen = startOpen;
		this.lastOpen = lastOpen;
		attachMovie("SelectableHandle", "anchorHandle", 0).init(this);
		attachMovie("ControlHandle", "controlAHandle", 1).init(this);
		attachMovie("ControlHandle", "controlBHandle", 2).init(this);
		initBeforeMove();
		return this;
	}
	public function initBeforeMove() {
		originalVertex = vertex.clone();
		update();
	}
	public function update() {
		var anchor = vertex.getAnchor();
		anchorHandle.setPosition(anchor.x, anchor.y);
		if (startOpen) {
			controlAHandle.hide();
		} else {
			var prePoint = (preVertex.getControlB().exist()) ? preVertex.getControlB().getPoint() : preVertex.getAnchor();
			updateControl(vertex.getControlA(), controlAHandle, prePoint);
		}
		if (lastOpen) {
			controlBHandle.hide();
		} else {
			var nextPoint = (nextVertex.getControlA().exist()) ? nextVertex.getControlA().getPoint() : nextVertex.getAnchor();
			updateControl(vertex.getControlB(), controlBHandle, nextPoint);
		}
		var scale = 100 * 100/owner.getCanvasScale();
		anchorHandle.setScale(scale);
		controlAHandle.setScale(scale);
		controlBHandle.setScale(scale);
		drawPathPart();
	}
	private function updateControl(control, handle, neighbor:Point) {
		if (control.exist()) {
			handle.setPosition(control.x, control.y);
			handle.activate();
			handle.show();
		} else {
			if (anchorHandle.isSelected()) {
				var anchor = vertex.getAnchor();
				var d:Point = neighbor.subtract(anchor);
				var length = d.length;
				var x = anchor.x + d.x*12/length;
				var y = anchor.y + d.y*12/length;
				handle.setPosition(x, y);
				handle.inactivate();
				handle.show();
			} else {
				handle.hide();
			}
		}
	}
	public function getOriginalAnchor():Point {
		return this.originalVertex.getAnchor();
	}
	
	//
	// draw
	//
	private function drawPathPart() {
		clear();
		if ( ! lastOpen) {
			lineStyle(10, 0x000000, 0);
			drawPathPartStroke();
			lineStyle(0, 0x0000FF, 30);
			drawPathPartStroke();
		}
		lineStyle(0, 0x0000FF, 30);
		drawControleLine();
	}
	private function drawControleLine() {
		var anchor = vertex.getAnchor();
		if (vertex.getControlA().exist() && ! startOpen) {
			var c = vertex.getControlA();
			moveTo(anchor.x, anchor.y);
			lineTo(c.x, c.y);
		}
		if (vertex.getControlB().exist() && ! lastOpen) {
			var c = vertex.getControlB();
			moveTo(anchor.x, anchor.y);
			lineTo(c.x, c.y);
		}
	}
	private function drawPathPartStroke() {
		var p1 = vertex.getAnchor();
		var p2 = nextVertex.getAnchor();
		moveTo(p1.x, p1.y);
		if (vertex.getControlB().exist() || nextVertex.getControlA().exist()) {
			var c1 = (vertex.getControlB().exist()) ? vertex.getControlB() : p1;
			var c2 = (nextVertex.getControlA().exist()) ? nextVertex.getControlA() : p2;
			bezierTo(p1.x, p1.y, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
		} else {
			lineTo(p2.x, p2.y);
		}
	}
	
	//
	// Handle Selection
	//
	public function unselectHandle() {
		anchorHandle.unselect();
		controlAHandle.unselect();
		controlBHandle.unselect();
	}
	public function isAnchorSelected():Boolean {
		return anchorHandle.isSelected();
	}
	public function isControlASelected():Boolean {
		return controlAHandle.isSelected();
	}
	public function isControlBSelected():Boolean {
		return controlBHandle.isSelected();
	}
	public function moveHandle(d:Point) {
		var x = originalVertex.getAnchor().x + d.x;
		var y = originalVertex.getAnchor().y + d.y;
		vertex.setAnchor(new Point(x, y));
		if (vertex.getControlA().exist()) {
			var x = originalVertex.getControlA().x + d.x;
			var y = originalVertex.getControlA().y + d.y;
			vertex.setControlA( new Control(new Point(x, y)) );
		}
		if (vertex.getControlB().exist()) {
			var x = originalVertex.getControlB().x + d.x;
			var y = originalVertex.getControlB().y + d.y;
			vertex.setControlB( new Control(new Point(x, y)) );
		}
	}
	
	private function getHandleLength(control) {
		if (control.exist()) {
			return Point.distance(vertex.getAnchor(), control.getPoint());
		} else {
			return 0;
		}
	}
	
	private function createSymmetryControl(pos:Point):Control {
		var anchor = vertex.getAnchor();
		var d:Point = pos.subtract(anchor);
		var x = anchor.x - d.x;
		var y = anchor.y - d.y;
		return new Control(new Point(x, y));
	}
	private function createAsymmetryControl(pos:Point):Control {
		var anchor = vertex.getAnchor();
		var d:Point = pos.subtract(anchor);
		var length:Number = d.length;
		var x = anchor.x - d.x * oppositeHandleLength/length;
		var y = anchor.y - d.y * oppositeHandleLength/length;
		return new Control(new Point(x, y));
	}
	
	//
	// Handle Event
	//
	function onHandlePress(h) {
		if (h.getHandleType() == "anchor") {
			if (Key.isDown(Key.SHIFT)) {
				h.toggle();
			} else {
				if ( ! h.isSelected()) {
					owner.unselectAllHandles();
					h.select();
				}
			}
		} else if (h._name == "controlAHandle") {
			oppositeHandleLength = getHandleLength(vertex.getControlB());
			owner.unselectAllHandles();
			h.select();
		} else if (h._name == "controlBHandle") {
			oppositeHandleLength = getHandleLength(vertex.getControlA());
			owner.unselectAllHandles();
			h.select();
		}
	}
	function onHandleDrag(h) {
		if (h.getHandleType() == "anchor") {
			var d:Point = h.getDistance();
			owner.moveSelectedHandles(d);
			owner.updateVertexHandles();
		} else if (h._name == "controlAHandle") {
			var pos = h.getPosition();
			if (owner.isSnapping()) {
				pos = Snap.snappedPoint(pos, 20);
			}
			vertex.setControlA( new Control(pos) );
			if (Key.isDown(Key.CONTROL)) {
				if (oppositeHandleLength>0) {
					vertex.setControlB(createAsymmetryControl(pos) );
				} else {
					vertex.setControlB(createSymmetryControl(pos) );
				}
			}
			owner.updateVertexHandles();
		} else if (h._name == "controlBHandle") {
			var pos = h.getPosition();
			if (owner.isSnapping()) {
				pos = Snap.snappedPoint(pos, 20);
			}
			vertex.setControlB( new Control(pos) );
			if (Key.isDown(Key.CONTROL)) {
				if (oppositeHandleLength>0) {
					vertex.setControlA(createAsymmetryControl(pos) );
				} else {
					vertex.setControlA(createSymmetryControl(pos) );
				}
			}
			owner.updateVertexHandles();
		}
	}
	function onHandleStopDrag(h) {
		onHandleDrag(h);
		owner.onHandleStopDrag();
	}
	//
	// MouseEvent
	//
	function onMouseDown() {
		if (Key.isDown(65)) { // "A"
			if (hitTest(_root._xmouse, _root._ymouse, true)) {
				vertex.clearControlB();
				nextVertex.clearControlA();
				owner.addVertexAt( this.index+1);
			}
		}
	}
}

