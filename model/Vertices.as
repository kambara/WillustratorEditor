import util.*;
import model.*;
import flash.geom.*;

class model.Vertices {
	// 10,10 20,20|30,10|50,50
	// Vertexのコレクション
	private var vertices:Array;
	
	function Vertices() {
		vertices = new Array();
	}
	public function addItem(v:Vertex) {
		vertices.push(v);
	}
	public function addItemAt(i:Number, v:Vertex) {
		vertices.splice(i, 0, v);
	}
	public function getItemAt(i:Number):Vertex {
		return Vertex(vertices[i]);
	}
	public function getLastItem():Vertex {
		return Vertex(vertices[vertices.length-1]);
	}
	public function removeItemAt(i:Number):Void {
		vertices.splice(i, 1);
	}
	public function getLength():Number {
		return vertices.length;
	}
	public function clone():Vertices {
		var vs:Vertices = new Vertices();
		for (var i=0; i<vertices.length; i++) {
			vs.addItem(getItemAt(i).clone());
		}
		return vs;
	}
	public function move(d):Void {
		for (var i=0; i<vertices.length; i++) {
			getItemAt(i).move(d);
		}
	}
	public function scale(scaleX:Number, scaleY:Number) {
		for (var i=0; i<vertices.length; i++) {
			getItemAt(i).scale(scaleX, scaleY);
		}
	}
	public function getLeft():Number {
		var left:Number;
		for (var i=0; i<vertices.length; i++) {
			var v:Vertex = getItemAt(i);
			var x:Number = v.getAnchor().x;
			if (i==0) {
				left = x;
			} else {
				left = Math.min(left, x);
			}
			if (v.getControlA().exist()) {
				left = Math.min(left, v.getControlA().x);
			}
			if (v.getControlB().exist()) {
				left = Math.min(left, v.getControlB().x);
			}
		}
		return left;
	}
	public function getRight():Number {
		var right:Number;
		for (var i=0; i<vertices.length; i++) {
			var v:Vertex = getItemAt(i);
			var x:Number = v.getAnchor().x;
			if (i==0) {
				right = x;
			} else {
				right = Math.max(right, x);
			}
			if (v.getControlA().exist()) {
				right = Math.max(right, v.getControlA().x);
			}
			if (v.getControlB().exist()) {
				right = Math.max(right, v.getControlB().x);
			}
		}
		return right;
	}
	public function getTop():Number {
		var top:Number;
		for (var i=0; i<vertices.length; i++) {
			var v:Vertex = getItemAt(i);
			var y:Number = v.getAnchor().y;
			if (i==0) {
				top = y;
			} else {
				top = Math.min(top, y);
			}
			if (v.getControlA().exist()) {
				top = Math.min(top, v.getControlA().y);
			}
			if (v.getControlB().exist()) {
				top = Math.min(top, v.getControlB().y);
			}
		}
		return top;
	}
	public function getBottom():Number {
		var bottom:Number;
		for (var i=0; i<vertices.length; i++) {
			var v:Vertex = getItemAt(i);
			var y:Number = v.getAnchor().y;
			if (i==0) {
				bottom = y;
			} else {
				bottom = Math.max(bottom, y);
			}
			if (v.getControlA()) {
				bottom = Math.max(bottom, v.getControlA().y);
			}
			if (v.getControlB()) {
				bottom = Math.max(bottom, v.getControlB().y);
			}
		}
		return bottom;
	}
	public function getRectangle():Rectangle {
		if (vertices.length == 0) return new Rectangle();
		
		var rect:Rectangle = null;
		for (var i=0; i<vertices.length; i++) {
			var v:Vertex = getItemAt(i);
			var anchor:Point = v.getAnchor();
			if (i==0) {
				rect = new Rectangle(anchor.x, anchor.y, 1, 1);
			} else {
				rect = rect.union(new Rectangle(anchor.x, anchor.y, 1, 1));
			}
			if (v.getControlA().exist()) {
				var ca:Control = v.getControlA();
				rect = rect.union(new Rectangle(ca.x, ca.y, 1, 1));
			}
			if (v.getControlB().exist()) {
				var cb:Control = v.getControlB();
				rect = rect.union(new Rectangle(cb.x, cb.y, 1, 1));
			}
		}
		return rect;
	}
	public function toString():String {
		var str = "";
		for (var i=0; i<vertices.length; i++) {
			if (i > 0) {
				str += " ";
			}
			str += getItemAt(i).toString();
		}
		return str;
	}
	public static function createFromString(str:String):Vertices {
		var vs:Vertices = new Vertices();
		var vlist:Array = str.split(" ");
		for (var i=0; i<vlist.length; i++) {
			var v:Vertex = Vertex.createFromString(vlist[i]);
			if (v) {
				vs.addItem(v);
			}
		}
		return vs;
	}
	public static function createFromSVGPath(str:String):Vertices {
		// 分解
		var cmds:Array = [];
		var buf = "";
		for (var i=0; i <= str.length; i++) {
			var c = (i==str.length) ? null : str.charAt(i); // 最後はnull
			switch(c) {
			case "M":
			case "C":
			case "c":
			case "S":
			case "s":
			case "L":
			case "l" :
			case "Z":
			case "z":
			case null:
				if (buf != "") {
					var cmd:Array = [];
					var b = buf.split(" ");
					for (var j=0; j<b.length; j++) {
						if (b[j] == "") continue;
						if (cmd.length == 0) {
							cmd.push(b[j]);
						} else {
							cmd.push(parseFloat(b[j]));
						}
					}
					cmds.push(cmd);
				}
				buf = c + " ";
				break;
			case "\r":
			case "\n":
			case "\t":
			case ",":
				buf += " ";
				break;
			case "-":
				buf += " -";
				break;
			default:
				buf += c;
				break;
			}
		}
		/*
		for (var i=0; i<cmds.length; i++) {
			trace(cmds[i]);
		}
		*/
		// 相対座標を絶対座標に変換 c->C s->C l->L
		var prePoint:Point;
		for (var i=0; i<cmds.length; i++) {
			var cmd = cmds[i];
			switch (cmd[0]) {
				case "M":
				case "L":
					prePoint = new Point(cmd[1], cmd[2]);
					break;
					
				case "C":
					prePoint = new Point(cmd[5], cmd[6]);
					break;
				case "S":
					prePoint = new Point(cmd[3], cmd[4]);
					break;
				
				case "c":
					var newCmd:Array = [];
					newCmd.push("C");
					newCmd.push(prePoint.x + cmd[1]);
					newCmd.push(prePoint.y + cmd[2]);
					newCmd.push(prePoint.x + cmd[3]);
					newCmd.push(prePoint.y + cmd[4]);
					newCmd.push(prePoint.x + cmd[5]);
					newCmd.push(prePoint.y + cmd[6]);
					cmds[i] = newCmd;
					prePoint = new Point(newCmd[5], newCmd[6]);
					break;
				case "s":
					var newCmd:Array = [];
					newCmd.push("S");
					newCmd.push(prePoint.x + cmd[1]);
					newCmd.push(prePoint.y + cmd[2]);
					newCmd.push(prePoint.x + cmd[3]);
					newCmd.push(prePoint.y + cmd[4]);
					cmds[i] = newCmd;
					prePoint = new Point(newCmd[3], newCmd[4]);
					break;
				case "l":
					var newCmd:Array = [];
					newCmd.push("L");
					newCmd.push(prePoint.x + cmd[1]);
					newCmd.push(prePoint.y + cmd[2]);
					cmds[i] = newCmd;
					prePoint = new Point(newCmd[1], newCmd[2]);
					break;
			}
		}
		/*
		for (var i=0; i<cmds.length; i++) {
			trace(cmds[i].length + " "+cmds[i]);
		}
		*/
		
		// Vertexに変換
		var vs:Vertices = new Vertices();
		for (var i=0; i<cmds.length; i++) {
			var cmd = cmds[i];
			var nextCmd = (i+1 < cmds.length) ? cmds[i+1] : null;
			switch (cmd[0]) {
				case "M":
				case "L":
					var v:Vertex = new Vertex(new Point(cmd[1], cmd[2]));
					if (nextCmd && nextCmd[0] == "C") {
						v.setControlB(new Control(new Point(nextCmd[1], nextCmd[2])));
					}
					vs.addItem(v.clone());
					break;
				case "C":
					var v:Vertex = new Vertex(new Point(cmd[5], cmd[6]));
					v.setControlA(new Control(new Point(cmd[3], cmd[4])));
					if (nextCmd && nextCmd[0] == "C") {
						v.setControlB(new Control(new Point(nextCmd[1], nextCmd[2])));
					}
					if (nextCmd && nextCmd[0] == "S") {
						v.setControlB(new Control( symmetricPoint(
							new Point(cmd[3], cmd[4]),
							v.getAnchor()
						) ));
					}
					vs.addItem(v.clone());
					break;
				case "S":
					var v:Vertex = new Vertex(new Point(cmd[3], cmd[4]));
					v.setControlA(new Control(new Point(cmd[1], cmd[2])));
					if (nextCmd && nextCmd[0] == "C") {
						v.setControlB(new Control(new Point(nextCmd[1], nextCmd[2])));
					}
					if (nextCmd && nextCmd[0] == "S") {
						v.setControlB(new Control( symmetricPoint(
							v.getControlA().getPoint(),
							v.getAnchor()
						) ));
					}
					vs.addItem(v.clone());
					break;
			}
		}
		//vs.addItem(v.clone());
		return vs;
		
		function symmetricPoint(orig:Point, pivot:Point) {
			var d:Point = pivot.subtract(orig);
			return pivot.add(d)
		}
	}
	private function getBeziers(i):Array {
		var beziers:Array = [];
		for (var i=1; i<getLength(); i++) {
			var va:Vertex = getItemAt(i-1);
			var vb:Vertex = getItemAt(i);
			var p0:Point = va.getAnchor();
			var p1:Point = (va.getControlB().exist())
									? va.getControlB().getPoint()
									: va.getAnchor();
			var p2:Point = (vb.getControlA().exist())
									? vb.getControlA().getPoint()
									: vb.getAnchor();
			var p3:Point = vb.getAnchor();
			beziers.push([p0, p1, p2, p3]);
		}
		return beziers;
	}
	private function bezierToPoints(p0, p1, p2, p3, length) {
		// if length==20
		// -> 0/19 ～ 19/19 (20個の点)
		function a(x0, x1, x2, x3) {
			return x3 - 3*x2 + 3*x1 - x0;
		}
		function b(x0, x1, x2) {
			return 3*x2 - 6*x1 + 3*x0;
		}
		function c(x0, x1) {
			return 3*x1 - 3*x0;
		}
		function d(x0) {
			return x0;
		}
		function bernstein(a, b, c, d, t) {
			return a*t*t*t + b*t*t + c*t + d;
		}
		var ax = a(p0.x, p1.x, p2.x, p3.x)
		var bx = b(p0.x, p1.x, p2.x);
		var cx = c(p0.x, p1.x);
		var dx = d(p0.x);
		var ay = a(p0.y, p1.y, p2.y, p3.y)
		var by = b(p0.y, p1.y, p2.y);
		var cy = c(p0.y, p1.y);
		var dy = d(p0.y);
		
		var points:Array = [];
		for (var i = 0; i<=length-1; i++) {
			var t = i / (length-1);
			
			var x = bernstein(ax, bx, cx, dx, t);
			var y = bernstein(ay, by, cy, dy, t);
			points.push( new Point(Math.round(x), Math.round(y)) );
		}
		return points;
	}
	public function getPoints():Array {
		var points:Array = new Array();
		var beziers:Array = getBeziers();
		for (var i=0; i<beziers.length; i++) {
			var bez = beziers[i];
			var pts:Array = bezierToPoints(bez[0], bez[1], bez[2], bez[3], 10);
			points = points.concat(pts);
		}
		return points;
	}
}