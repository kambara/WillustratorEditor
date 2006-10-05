import util.*;
import model.*;
import canvas.*;
import canvas.shape.*;
import canvas.layer.*;
import flash.geom.*;

class canvas.layer.ShapesLayer extends Layer {
	private var currentShapeNames:Array; // MC全削除用
	private var draggingFrame:WillustratorDrawingMC;
	
	function createChildren():Void {
		var shapeCollection:ShapeCollection = main.getDocument().getShapeCollection();
		removeAllShapes();
		attachMovie("WillustratorDrawingMC", "draggingFrame", shapeCollection.getLength()+1);
		currentShapeNames = new Array();
		for (var i=0; i<shapeCollection.getLength(); i++) {
			var shapeModel:IShapeModel = shapeCollection.getItemAt(i);
			if ( shapeModel.getShapeType() != null ) {
				var shapeName = "s"+i;
				attachMovie(shapeModel.getShapeType(), shapeName, i).init(shapeModel, main, draggingFrame);
				currentShapeNames.push(shapeName);
			}
		}
		//invalidate();
	}
	/****
	public function update() {
		var shapeCollection:ShapeCollection = main.getDocument().getShapeCollection();
		removeAllShapes();
		attachMovie("WillustratorDrawingMC", "draggingFrame", shapeCollection.getLength()+1);
		currentShapeNames = new Array();
		for (var i=0; i<shapeCollection.getLength(); i++) {
			var shapeModel:IShapeModel = shapeCollection.getItemAt(i);
			if ( shapeModel.getShapeType() != null ) {
				var shapeName = "s"+i;
				attachMovie(shapeModel.getShapeType(), shapeName, i).init(shapeModel, main, draggingFrame);
				currentShapeNames.push(shapeName);
			}
		}
	}
	*****/
	public function draw() {
		for (var i=0; i<currentShapeNames.length; i++) {
			this[currentShapeNames[i]].draw();
		}
	}
	
	public function dragSelectedShapes(d:Point):Void {
		var sc = main.getSelectedShapes();
		if (sc.getLength() > 0) {
			var rect = sc.getRectangle();
			if (main.getDocument().isSnapping()) {
				d = Snap.snappedDistance(
					d,
					rect.left,
					rect.right,
					rect.top,
					rect.bottom,
					20
				);
			}
			
			draggingFrame.clear();
			draggingFrame.drawRectLine(
				rect.left + d.x,
				rect.top + d.y,
				rect.width,
				rect.height,
				0, 0x000000, 100
			);
		}
	}
	/*
	public function getHitShapeIndexes(target):Array { // 複数選択
		var indexes:Array = new Array();
		for (var i=0; i<currentShapeNames.length; i++) {
			var s = this[currentShapeNames[i]];
			if (s.hitTo(target)) {
				indexes.push(s.getDepth());
			}
		}
		return indexes;
	}
	*/
	private function removeAllShapes() {
		draggingFrame.removeMovieClip();
		if ( !currentShapeNames || currentShapeNames.length==0 ) return;
		for (var i=0; i<currentShapeNames.length; i++) {
			this[currentShapeNames[i]].removeMovieClip();
		}
	}
}
