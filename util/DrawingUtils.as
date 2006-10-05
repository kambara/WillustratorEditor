import util.*;
import flash.geom.*;

class util.DrawingUtils {
	static var _drawingUtils:DrawingUtils;
	static function initialize(object:Object) {
		if (_drawingUtils == undefined) {
			_drawingUtils = new DrawingUtils();
		}
		object.drawLine = _drawingUtils.drawLine;
	}
	
	function drawLine(x1:Number, y1:Number, x2:Number, y2:Number, style:Object) {
		if (style.lineWidth != undefined && style.lineColor != undefined && style.lineAlpha != undefined) {
			lineStyle(style.lineWidth, style.lineColor, style.lineAlpha);
		}
		moveTo(x1, y1);
		lineTo(x2, y2);
	}
	
	//
	// ただの長方形
	//
	/*
	function drawFillRect(x, y, w, h, lineWidth, lineColor, lineAlpha, fillColor, fillAlpha) {
		beginFill(fillColor, fillAlpha);
		drawRectLine(x, y, w, h, lineWidth, lineColor, lineAlpha);
		endFill();
	}
	function drawRectLine(x, y, w, h, lineWidth, lineColor, lineAlpha) {
		lineStyle(lineWidth, lineColor, lineAlpha);
		drawRect(x, y, w, h);
	}
	function drawRect(x, y, w, h) {
		moveTo(x, y);
		lineTo(x+w, y);
		lineTo(x+w, y+h);
		lineTo(x, y+h);
		lineTo(x, y);
	}
	
	//
	// 角丸の長方形
	//
	function drawFillRoundRect(x, y, w, h, rx, ry, lineWidth, lineColor, lineAlpha, fillColor, fillAlpha) {
		beginFill(fillColor, fillAlpha);
		drawRoundRectLine(x, y, w, h, rx, ry, lineWidth, lineColor, lineAlpha);
		endFill();
	}
	function drawRoundRectLine(x, y, w, h, rx, ry, lineWidth, lineColor, lineAlpha) {
		lineStyle(lineWidth, lineColor, lineAlpha);
		drawRoundRect(x, y, w, h, rx, ry);
	}
	function drawRoundRect(x, y, width, height,  xradius, yradius) {
		if (xradius>0 && yradius>0) {
			var l = x;
			var r = x+width;
			var t = y;
			var b = y+height
			
			var l2 = l+xradius;
			var r2 = r-xradius;
			var t2 = t+yradius;
			var b2 = b-yradius;
			
			// 反時計回りに四角を書く
			
			moveTo(l, t2);
			lineTo(l, b2); // 左直線
			arcTo(l, b2, xradius, yradius, 90, 180);
			lineTo(r2, b); // 下直線
			arcTo(r2, b, xradius, yradius, 90, 270);
			lineTo(r, t2); // 右直線
			arcTo(r, t2,  xradius, yradius, 90, 0);
			lineTo(l2, t); // 上直線
			arcTo(l2, t, xradius, yradius, 90, 90);
		} else {
			moveTo(x, y);
			lineTo(x+width, y);
			lineTo(x+width, y+height);
			lineTo(x, y+height);
			lineTo(x, y);
		}
	}
	
	//
	// 楕円
	//
	function drawFillOval(x, y, radius, yRadius, lineWidth, lineColor, lineAlpha, fillColor, fillAlpha) {
		beginFill(fillColor, fillAlpha);
		drawOvalLine(x, y, radius, yRadius, lineWidth, lineColor, lineAlpha)
		endFill();
	}
	function drawOvalLine(x, y, radius, yRadius, lineWidth, lineColor, lineAlpha) {
		lineStyle(lineWidth, lineColor, lineAlpha);
		drawOval(x, y, radius, yRadius);
	}
	function drawOval(x, y, radius, yRadius) {
		if (arguments.length<3)  return;
		if (yRadius == undefined) yRadius = radius;
		
		var theta = Math.PI/4;
		// calculate the distance for the control point
		var xrCtrl = radius/Math.cos(theta/2);
		var yrCtrl = yRadius/Math.cos(theta/2);
		var angle = 0;
		this.moveTo(x+radius, y);
		for (var i = 0; i<8; i++) {
			// increment our angles
			angle += theta;
			var angleMid = angle-(theta/2);
			// calculate our control point
			var cx = x+Math.cos(angleMid)*xrCtrl;
			var cy = y+Math.sin(angleMid)*yrCtrl;
			// calculate our end point
			var px = x+Math.cos(angle)*radius;
			var py = y+Math.sin(angle)*yRadius;
			// draw the circle segment
			this.curveTo(cx, cy, px, py);
		}
	}
	//
	// 弧 (x, yに描画開始点を移動しておく必要がある) 反時計回りに弧を描く。3時の方向が0度
	//
	function arcTo(x, y, xradius, yradius, arc, startAngle) {
		if (arguments.length<6) return;
		
		if (Math.abs(arc)>360) arc = 360;
		
		var segs = Math.ceil(Math.abs(arc)/45);
		// segあたりの角度
		var segAngle = arc/segs;
		var theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		var angle = -(startAngle/180)*Math.PI;
		// 原点
		var ax = x-Math.cos(angle)*xradius;
		var ay = y-Math.sin(angle)*yradius;
		if (segs>0) {
			for (var i = 0; i<segs; i++) {
				angle += theta;
				var angleMid = angle-(theta/2);
				
				var bx = ax+Math.cos(angle)*xradius;
				var by = ay+Math.sin(angle)*yradius;
				// control point
				var cx = ax+Math.cos(angleMid)*(xradius/Math.cos(theta/2));
				var cy = ay+Math.sin(angleMid)*(yradius/Math.cos(theta/2));
				this.curveTo(cx, cy, bx, by);
			}
		}
		return {x:bx, y:by};
	}
	
	//
	// 3次ベジェ
	//
	function bezierTo(x1, y1, x2, y2, x3, y3, x4, y4) {
		bezierTo2(x1, y1, x2, y2, x3, y3, x4, y4, 0);
	}
	private function bezierTo2(x1, y1, x2, y2, x3, y3, x4, y4, depth) {
		if (depth>3) {
			curveTo(x2, y2, x4, y4);
			return;
		}
		var mid_x = (x1+3*x2+3*x3+x4)/8;
		var mid_y = (y1+3*y2+3*y3+y4)/8;
		bezierTo2(x1, y1, (x1+x2)/2, (y1+y2)/2, (x1+2*x2+x3)/4, (y1+2*y2+y3)/4, mid_x, mid_y, depth+1);
		bezierTo2(mid_x, mid_y, (x2+2*x3+x4)/4, (y2+2*y3+y4)/4, (x3+x4)/2, (y3+y4)/2, x4, y4, depth+1);
	}
	//
	// ポリライン
	//
	function drawPolyline(ps:Array) {
		moveTo(ps[0].x, ps[0].y); // 始点
		for (var i=1; i<ps.length; i++) {
			lineTo(ps[i].x, ps[i].y);
		}
	}
	//
	// ポリゴン
	//
	function drawPolygon(ps:Array) {
		// Pointの配列を渡す
		moveTo(ps[0].x, ps[0].y); // 始点
		for (var i=1; i<ps.length; i++) {
			lineTo(ps[i].x, ps[i].y);
		}
		lineTo(ps[0].x, ps[0].y); // 線を閉じる
	}
	*/
}