import model.*;
import util.*;
import flash.geom.*;

class model.ShapeCollection {
	private var shapes:Array;
	
	function ShapeCollection() {
		shapes = new Array();
	}
	public function addItem(shape):Void {
		if (shape) {
			shapes.push(shape);
		}
	}
	public function addItemAt(index, shape):Void {
		if (shape) {
			shapes.splice(index, 0, shape);
		}
	}
	public function getItemAt(i):IShapeModel {
		return IShapeModel(shapes[i]);
	}
	public function getShapeCollectionToIntersect(rect:Rectangle):ShapeCollection {
		var sc = new ShapeCollection();
		for (var i=0; i<shapes.length; i++) {
			var s = getItemAt(i);
			if (s.intersects(rect)) {
				sc.addItem(s);
			}
		}
		return sc;
	}
	public function removeItemAt(i) {
		shapes.splice(i, 1);
	}
	public function removeAll() {
		shapes = new Array();
	}
	public function removeItem(shape):Boolean {
		for (var i=0; i<shapes.length; i++) {
			if (getItemAt(i).getID() == shape.getID()) {
				removeItemAt(i);
				return true;
			}
		}
		return false;
	}
	public function getIndexOf(shape):Number {
		for (var i=0; i<shapes.length; i++) {
			if (getItemAt(i).getID() == shape.getID()) {
				return i;
			}
		}
		return null;
	}
	public function moveIndexOf(shape, index):Void {
		var i = getIndexOf(shape);
		var s = shape.clone();
		shapes.removeItemAt(i);
		shapes.addItemAt(index, s);
	}
	public function have(shape) {
		for (var i=0; i<shapes.length; i++) {
			if (getItemAt(i).getID() == shape.getID()) {
				return true;
			}
		}
		return false;
	}
	public function getLength() {
		return shapes.length;
	}
	public function clone() {
		var sc = new ShapeCollection();
		for (var i=0; i<shapes.length; i++) {
			sc.addItem(shapes[i].clone());
		}
		return sc;
	}
	public function move(d:Point, snapping:Boolean) {
		var rect:Rectangle = getRectangle();
		if (snapping) {
			d = Snap.snappedDistance(d,
									 rect.left, rect.right,
									 rect.top, rect.bottom,
									 20);
		}
		for (var i=0; i<shapes.length; i++) {
			getItemAt(i).move(d);
		}
	}
	public function scale(scaleX:Number, scaleY:Number) {
		for (var i=0; i<shapes.length; i++) {
			getItemAt(i).scale(scaleX, scaleY);
		}
	}
	
	private function min(numbers:Array):Number {
		if (numbers.length == 0) {
			return null;
		} else if (numbers.length == 1) {
			return numbers[0];
		}
		var min:Number = numbers[0];
		for(var i=1; i<numbers.length; i++) {
			if (numbers[i] < min) {
				min = numbers[i];
			}
		}
		return min;
	}
	private function max(numbers:Array):Number {
		if (numbers.length == 0) {
			return null;
		} else if (numbers.length == 1) {
			return numbers[0];
		}
		var max:Number = numbers[0];
		for(var i=1; i<numbers.length; i++) {
			if (numbers[i] > max) {
				max = numbers[i];
			}
		}
		return max;
	}
	public function getLeft():Number {
		if (shapes.length == 0)
			return 0;
		var nums:Array = new Array();
		for (var i=0; i<shapes.length; i++) {
			nums.push(getItemAt(i).getLeft());
		}
		return min(nums);
	}
	public function getRight():Number {
		if (shapes.length == 0)
			return 0;
		var nums:Array = new Array();
		for (var i=0; i<shapes.length; i++) {
			nums.push(getItemAt(i).getRight());
		}
		return max(nums);
	}
	public function getTop():Number {
		if (shapes.length == 0)
			return 0;
		var nums:Array = new Array();
		for (var i=0; i<shapes.length; i++) {
			nums.push(getItemAt(i).getTop());
		}
		return min(nums);
	}
	public function getBottom():Number {
		if (shapes.length == 0)
			return 0;
		var nums:Array = new Array();
		for (var i=0; i<shapes.length; i++) {
			nums.push(getItemAt(i).getBottom());
		}
		return max(nums);
	}
	public function getRectangle():Rectangle {
		if (shapes.length == 0) return new Rectangle();
		
		var rect:Rectangle = getItemAt(0).getRectangle();
		if (shapes.length == 1) return rect;
		
		for (var i=1; i<shapes.length; i++) {
			rect = rect.union(getItemAt(i).getRectangle());
		}
		return rect;
	}
}
