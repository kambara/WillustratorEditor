import util.*;
import model.*;
import canvas.edit.*;
import canvas.edit.handle.*;
import flash.geom.*;

class canvas.edit.PathEdit extends ShapeEdit {
	private var vertices:Vertices; // 編集用のvertices
	private var vertexHandlesList:Array;
	private var sizer:Sizer;
	private var editSize:Boolean = false;
	
	public function update() {
		this.vertices = shapeModel.vertices.clone();
		createChildren();
		if (editSize) {
			updateSizer();
		} else {
			updateVertexHandles();
		}
	}
	function createChildren() {
		// Remove
		if (sizer) {
			sizer.removeMovieClip();
		}
		if (vertexHandlesList) {
			for (var i=0; i<vertexHandlesList.length; i++) {
				vertexHandlesList[i].removeMovieClip();
			}
		}
		
		// Sizer
		if (editSize) {
			attachMovie("Sizer", "sizer", 0).init(this);
		} else {
			attachVertexHandles();
		}
		Key.addListener(this);
	}
	
	private function attachVertexHandles() {
		this.vertexHandlesList = new Array();
		for (var i=0; i<vertices.getLength(); i++) {
			var v:Vertex = vertices.getItemAt(i);
			var p:Vertex = (i == 0) ? vertices.getLastItem() : vertices.getItemAt(i-1);
			var n:Vertex = (i == vertices.getLength()-1) ? vertices.getItemAt(0) : vertices.getItemAt(i+1);
			var startOpen:Boolean = (i == 0 && shapeModel.closepath==false);
			var lastOpen:Boolean = (i == vertices.getLength()-1 && shapeModel.closepath==false);
			var vh = attachMovie("VertexHandles", "vh"+i.toString(), i).init(this, p, v, n, i, startOpen, lastOpen);
			vertexHandlesList.push(vh);
		}
	}
	
	private function updateSizer() {
		sizer.setRectangle(vertices.getRectangle());
	}
	public function updateVertexHandles() {
		for (var i=0; i<vertexHandlesList.length; i++) {
			vertexHandlesList[i].update();
		}
	}
	public function moveSelectedHandles(d) {
		if (isSnapping()) {
			var rect = getSelectedHandlesRectangle();
			d = Snap.snappedDistance(d,
									 rect.left, rect.right,
									 rect.top, rect.bottom,
									 20);
		}
		for (var i=0; i<vertexHandlesList.length; i++) {
			var h = vertexHandlesList[i];
			if (h.isAnchorSelected()) {
				h.moveHandle(d);
			}
		}
	}
	private function getSelectedHandlesRectangle():Rectangle {
		var rect:Rectangle = null;
		for (var i=0; i<vertexHandlesList.length; i++) {
			var h = vertexHandlesList[i];
			if (h.isAnchorSelected()) {
				var pos = h.getOriginalAnchor();
				if (rect == null) {
					rect = new Rectangle(pos.x, pos.y, 0, 0);
				} else {
					rect = rect.union(new Rectangle(pos.x, pos.y, 1, 1));
				}
			}
		}
		return rect;
	}
	public function unselectAllHandles() {
		for (var i=0; i<vertexHandlesList.length; i++) {
			vertexHandlesList[i].unselectHandle();
		}
	}
	private function deleteSelectedHandles() {
		var newVertices:Vertices = new Vertices();
		for (var i=0; i<vertexHandlesList.length; i++) {
			var vh = vertexHandlesList[i];
			var v = vertices.getItemAt(i);
			if ( ! vh.isAnchorSelected()) {
				if (vh.isControlASelected()) {
					v.clearControlA();
				}
				if (vh.isControlBSelected()) {
					v.clearControlB();
				}
				newVertices.addItem(v.clone());
			}
		}
		if (newVertices.getLength() <= 1) { // 頂点がひとつなら消す
			main.removeSelectedShapes();
		} else {
			shapeModel.vertices = newVertices.clone();
			update();
			main.onEditChanged();
		}
	}
	public function addVertexAt(i) {
		var pos:Point = editLayer.getCurrentMousePos();
		vertices.addItemAt(i, new Vertex(pos));
		shapeModel.vertices = vertices.clone();
		update();
		main.onEditChanged();
	}
	public function onHandleStopDrag() {
		for (var i=0; i<vertexHandlesList.length; i++) {
			vertexHandlesList[i].initBeforeMove();
		}
		shapeModel.vertices = vertices.clone();
		main.onEditChanged();
	}
	private function isPathHandlesSelected():Boolean {
		for (var i=0; i<vertexHandlesList.length; i++) {
			var vh = vertexHandlesList[i];
			if (vh.isAnchorSelected()
				|| vh.isControlASelected()
				|| vh.isControlBSelected()) {
				return true;
			}
		}
		return false;
	}
	
	public function changeEditType(type:String) {
		if (type == "size") {
			editSize = true;
		} else if (type == "path") {
			editSize = false;
		}
		update();
	}
	//
	// Sizer Event
	//
	public function onSizerChanged(rect:Rectangle, originalRect:Rectangle) {
		var scaleX = rect.width / originalRect.width;
		var scaleY = rect.height / originalRect.height;
		
		// scale
		var offset:Point = shapeModel.getRectangle().topLeft;
		shapeModel.move(new Point(-offset.x, -offset.y));
		shapeModel.scale(scaleX, scaleY);
		shapeModel.move(offset);

		// move
		var d:Point = rect.topLeft.subtract(originalRect.topLeft);
		shapeModel.move(d);
		
		main.onEditChanged();
		update(); // for update sizer
	}
	
	//
	// Key Event
	//
	function onKeyDown() {
		if (main.isPropertyFocused())
			return;
		if (isPathHandlesSelected()) {
			switch(Key.getCode()) {
				case Key.DELETEKEY:
				case Key.BACKSPACE:
					this.deleteSelectedHandles();
					break;
				case Key.UP:
					moveSelectedHandles(new Point(0, -1));
					onHandleStopDrag();
					break;
				case Key.DOWN:
					moveSelectedHandles(new Point(0, 1));
					onHandleStopDrag();
					break;
				case Key.LEFT:
					moveSelectedHandles(new Point(-1, 0));
					onHandleStopDrag();
					break;
				case Key.RIGHT:
					moveSelectedHandles(new Point(1, 0));
					onHandleStopDrag();
					break;
			}
		} else {
			super.onKeyDown();
		}
	}
}