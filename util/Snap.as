import util.*;
import flash.geom.*;

class util.Snap {
	static function snappedPoint(p:Point, interval:Number):Point {
		var offsetx = Snap.offset(p.x, interval);
		var offsety = Snap.offset(p.y, interval);
		p.x += (offsetx || 0);
		p.y += (offsety || 0);
		return p;
	}
	static function snappedDistance(d:Point, left:Number, right:Number, top:Number, bottom:Number, interval:Number) {
		// 補正前のdと補正前のrectを渡すと補正したdを返す
		var offset = Snap.offsetRect(
									 left + d.x, right + d.x,
									 top + d.y, bottom + d.y,
									 interval);
		//trace("left:"+(left+d.x)+" -> "+(left + d.x + offset.x));
		//trace("top:"+(top+d.y)+" ->  "+(top + d.y + offset.y));
		d.x += offset.x;
		d.y += offset.y;
		return d;
	}
	static function offsetRect(left:Number, right:Number, top:Number, bottom:Number, interval:Number) {
		var dx = Snap.minOffset(left, right, interval);
		var dy = Snap.minOffset(top, bottom, interval);
		return new Point(dx, dy);
	}
	
	static function minOffset(a:Number, b:Number, interval:Number) {
		// aとbの補正値が少ないほうの値を返す
		var offsetA:Number = Snap.offset(a, interval);
		var offsetB:Number = Snap.offset(b, interval);
		if (offsetA != null && offsetB != null) {
			return (Math.abs(offsetA) > Math.abs(offsetB)) ? offsetB : offsetA;
		} else if (offsetA != null && offsetB == null) {
			return offsetA;
		} else if (offsetA == null && offsetB != null) {
			return offsetB;
		} else {
			return 0;
		}
	}
	
	static function offset(a:Number, interval:Number):Number {
		var d:Number = a % interval;
		if (d > interval/2) {
			d = d - interval;
		}
		return (Math.abs(d) <= 4) ? -d : null;
	}
}