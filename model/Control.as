import util.*;
import flash.geom.*;

class model.Control {
	private var point:Point;
	
	function Control(p:Point) {
		point = p;
	}
	public function get x():Number {
		return point.x;
	}
	public function get y():Number {
		return point.y;
	}
	function setPoint(p:Point) {
		point = p;
	}
	function getPoint():Point {
		return point;
	}
	function exist():Boolean {
		return (point != null);
	}
	function clear():Void {
		point = null;
	}
	public function move(d):Void {
		if (exist()) {
			point.x += d.x;
			point.y += d.y;
		}
	}
	public function scale(scaleX:Number, scaleY:Number):Void {
		if (exist()) {
			point.x = point.x * scaleX;
			point.y = point.y * scaleY;
		}
	}
	function clone():Control {
		var c = new Control();
		if (exist()) {
			c.point = point.clone();
		}
		return c;
	}
	function toString():String {
		//return (exist()) ? point.toString() : "";
		return (exist()) ? [point.x, point.y].join(",") : "";
	}
}