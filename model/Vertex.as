import util.*;
import model.*;
import flash.geom.*;

class model.Vertex {
	private var anchor:Point;
	private var controlA:Control;
	private var controlB:Control;
	
	function Vertex(p) {
		anchor = p;
		controlA = new Control();
		controlB = new Control();
	}
	public function setAnchor(p:Point):Void {
		anchor = p;
	}
	public function getAnchor():Point {
		return anchor;
	}
	public function getAnchorFormatString():String {
		return anchor.x.toString() + "," + anchor.y.toString();
	}
	public function setControlA(c:Control):Void {
		controlA = c;
	}
	public function getControlA():Control {
		return controlA;
	}
	public function clearControlA():Void {
		controlA = null;
	}
	public function setControlB(c:Control):Void {
		controlB = c;
	}
	public function getControlB():Control {
		return controlB;
	}
	public function clearControlB():Void {
		controlB = null;
	}
	
	public function clone():Vertex {
		var v:Vertex = new Vertex(anchor.clone());
		if (controlA.exist()) {
			v.controlA = controlA.clone();
		}
		if (controlB.exist()) {
			v.controlB = controlB.clone();
		}
		return v;
	}
	public function move(d:Point):Void {
		anchor.x += d.x;
		anchor.y += d.y;
		controlA.move(d);
		controlB.move(d);
	}
	public function scale(scaleX:Number, scaleY:Number):Void {
		anchor.x = anchor.x * scaleX;
		anchor.y = anchor.y * scaleY;
		controlA.scale(scaleX, scaleY);
		controlB.scale(scaleX, scaleY);
	}
	public function toString():String {
		var str = anchor.x.toString()+","+anchor.y.toString();
		str = controlA.toString() + "|" + str + "|" + controlB.toString();
		return str;
	}
	public static function createPointFromString(str:String) {
		var buf:Array = str.split(",");
		if (buf.length<2)
			return null;
		return new Point(parseInt(buf[0]), parseInt(buf[1]));
	}
	public static function createFromString(str:String) {
		// 20,20|10,10|30,30
		var pointList:Array = str.split("|");
		if (pointList.length<3)
			return null;
		
		var p:Point = createPointFromString(pointList[1]);
		if (p==null)
			return null;
		var v:Vertex = new Vertex(p);
		
		p = createPointFromString(pointList[0]);
		v.setControlA(new Control(p));
		p = createPointFromString(pointList[2]);
		v.setControlB(new Control(p));
		return v;
	}
}