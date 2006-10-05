import util.*;
import model.*;
import canvas.shape.*;

class canvas.shape.Line extends Shape {
	private function draw():Void {
		clear();
		lineStyle(10, 0x000000, 0);
		drawLine(model.pointA.x, model.pointA.y,
				 model.pointB.x, model.pointB.y);
		
		lineStyle(model.lineWidth, model.lineColor, 100);
		drawLine(model.pointA.x, model.pointA.y,
				 model.pointB.x, model.pointB.y);
		
		switch (model.arrow) {
			case "both":
				drawArrow(model.pointA, model.pointB);
				drawArrow(model.pointB, model.pointA);
				break;
			case "end":
				drawArrow(model.pointA, model.pointB);
				break;
			case "start":
				drawArrow(model.pointB, model.pointA);
				break;
		}
	}
	
	private function drawArrow(a:Point, b:Point) {
		// a→bへの矢印を描く
		// 矢印の底の中心をhとする
		// 矢印の端をそれぞれc, dとする
		
		var m = 20; // hからbまでの長さ
		var r = degreeToRad(30); // 矢印の角度
		
		var ba:Point = new Point(a.x-b.x, a.y-b.y);
		var baLength:Number = Math.sqrt(ba.x*ba.x + ba.y*ba.y);
		var baUnit:Number = m/baLength;
		var bh:Point = new Point(
								ba.x * baUnit,
								ba.y * baUnit);
		var bc:Point = rot(bh, r);
		var bd:Point = rot(bh, -r);
		
		drawLine(b.x, b.y,
				 b.x + bc.x, b.y + bc.y);
		drawLine(b.x, b.y,
				 b.x + bd.x, b.y + bd.y);
	}
	private function rot(p:Point, r:Number):Point {
		// アフィン変換（回転）
		var sin = Math.sin(r);
		var cos = Math.cos(r);
		return new Point(
						 p.x*cos - p.y*sin,
						 p.x*sin + p.y*cos);
	}
	private function degreeToRad(d) {
		return d*Math.PI/180;
	}
	
	function hitTo(target:MovieClip) {
		var d = new Distance(model.pointA, model.pointB);
		var center = new Point(model.pointA.x + d.x/2,
							   model.pointA.y + d.y/2);
		return ( target.hitTest(model.pointA.x, model.pointA.y, true)
					|| target.hitTest(model.pointB.x, model.pointB.y, true)
					|| target.hitTest(center.x, center.y, true) );
	}
	
	function getLeftBottom() {
		var left = min(model.pointA.x, model.pointB.x);
		var bottom = max(model.pointA.y, model.pointB.y);
		return new Point(left, bottom);
	}
	private function min(a, b) {
		return (a<b) ? a : b;
	}
	private function max(a, b) {
		return (a>b) ? a : b;
	}
}
