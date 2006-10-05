import canvas.edit.handle.*;
import util.*;
import flash.geom.*;

class canvas.edit.handle.SizerCornerHandle extends Handle {
	var basicHandle:Handle;
	
	public function setBasicHandle(h) {
		basicHandle = h;
	}
	private function shiftNewPos(newPos:Point):Point {
		// basicHandleが原点になるよう移動
		var offset = basicHandle.getPosition();
		newPos.offset(-offset.x, -offset.y);
		
		var d:Point = dragStartPos.subtract(basicHandle.getPosition());
		var k = d.y / d.x; // 元のRectの傾き
		
		// 斜め方向に補正
		var newPosKatamuki = newPos.y / newPos.x;
		if (k > 0) { // 右下か左上方向
			if (newPosKatamuki < k) {
				newPos.y = k * newPos.x;
			} else {
				newPos.x = newPos.y / k;
			}
		} else {
			if (newPosKatamuki < k) {
				newPos.x = newPos.y / k;
			} else {
				newPos.y = k * newPos.x;
			}
		}
		// 元の位置に戻す
		newPos.offset(offset.x, offset.y);
		return newPos;
	}
	private function moveToNewPos(newPos):Void {
		if (owner.isSnapping()) {
			newPos = Snap.snappedPoint(newPos, 20);
		}
		if (Key.isDown(Key.SHIFT)) {
			newPos = shiftNewPos(newPos);
		}
		_x = newPos.x;
		_y = newPos.y;
	}
}
