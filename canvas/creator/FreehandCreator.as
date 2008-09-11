import util.*;
import canvas.creator.*;
import model.*;
import flash.geom.*;

class canvas.creator.FreehandCreator extends Creator {
	private var dragging:Boolean = false;
	private var beziers:Array;
	private var generator:BezierGenerator;
	private var tmpBezier;
	private var points:Array;
	private var firstTangent:Point;
	
	function onPress() {
		dragging = true;
		
		beziers = new Array();
		generator = new BezierGenerator({tolerance:3});
		tmpBezier = null;
		points = new Array();
		var pos = createShapeLayer.getCurrentMousePos();
		points.push(pos);
	}
	function onMouseMove() {
		if ( !dragging ) return;
		clear();
		
		var pos =  createShapeLayer.getCurrentMousePos();
		points.push(pos);
		
		var bez = generator.fromPoints(
									   points,
									   firstTangent || new Point(0, 0),
									   new Point(0, 0)
		);
		
		if (bez) {
			tmpBezier = bez;
		} else if (tmpBezier != null) {
			beziers.push(tmpBezier);
			
			var lastControlPos = tmpBezier[2];
			var lastPoint = tmpBezier[3];
			
			var da:Point = lastControlPos.subtract(lastPoint);
			var db:Point = pos.subtract(lastPoint);
			var cos = getCos(da, db);
			firstTangent = (cos && cos < -0.7)
				? new Point(
						lastPoint.x - lastControlPos.x,
						lastPoint.y - lastControlPos.y)
				: null;
			
			tmpBezier = null;
			points = new Array();
			points.push(lastPoint);
			points.push(pos);
		}
		drawBeziers();
		drawPoints();
		updateAfterEvent();
	}
	function getCos(da:Point, db:Point) {
		var da_db = da.x * db.x + da.y * db.y;
		var len = da.length * db.length;
		if (len > 0) {
			return da_db/len;
		} else {
			return null;
		}
	}
	function onMouseUp() {
		if ( !dragging ) return;
		dragging = false;
		
		var pos =  createShapeLayer.getCurrentMousePos();
		points.push(pos);
		var bez = generator.fromPoints(points, new Point(0, 0), new Point(0, 0));
		if (bez) {
			beziers.push(bez);
		}
		main.createPath(getVertices(), false);
	}
	
	private function getVertices() {
		var vertices = new Vertices();
		for (var i=0; i<beziers.length; i++) {
			var bez = beziers[i];
			if (i==0) {
				var firstv = new Vertex( roundPoint(bez[0]) );
				firstv.clearControlA();
				if ( Point.distance(bez[0], bez[1]) < 10 ) {
					firstv.clearControlB();
				} else {
					firstv.setControlB(new Control( roundPoint(bez[1]) ));
				}
				vertices.addItem(firstv);
			}
			
			// 前のポイントに近ければスキップ
			if ( Point.distance(bez[3], vertices.getLastItem().getAnchor()) < 10 ) continue;
			
			var v = new Vertex( roundPoint(bez[3]) );
			
			// ControlA
			if (Point.distance(bez[3], bez[2]) < 10) {
				// ControlがAnchorに近ければclearする
				v.clearControlA();
			} else {
				v.setControlA(new Control( roundPoint(bez[2]) ));
			}
			
			// ControlB
			var nextBez = beziers[i+1];
			if (nextBez) {
				if (Point.distance(nextBez[0], nextBez[1]) < 10) {
					v.clearControlB();
				} else {
					v.setControlB(new Control( roundPoint(nextBez[1]) ));
				}
			} else {
				v.clearControlB();
			}
			
			vertices.addItem(v);
		}
		return vertices;
	}
	private function roundPoint(p:Point):Point {
		return new Point(Math.round(p.x), Math.round(p.y));
	}
	private function drawPoints() {
		for (var i=0; i<points.length; i++) {
			var p = points[i];
			if (i==0) {
				lineStyle(1, 0xFF0000, 100);
				moveTo(p.x, p.y);
			} else {
				lineTo(p.x, p.y);
			}
		}
	}
	private function drawBeziers() {
		for (var i=0; i<beziers.length; i++) {
			var bez = beziers[i];
			if (i == 0) {
				lineStyle(1, 0x0000FF, 60);
				moveTo(bez[0].x, bez[0].y);
			}
			bezierTo(
				   bez[0].x, bez[0].y,
				   bez[1].x, bez[1].y,
				   bez[2].x, bez[2].y,
				   bez[3].x, bez[3].y
			);
		}
	}
}