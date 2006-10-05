import canvas.edit.handle.*;
import util.*;
import flash.geom.*;

class canvas.edit.handle.SizerVerticalHandle extends Handle {
	private function moveToNewPos(newPos):Void {
		if (owner.isSnapping()) {
			newPos = Snap.snappedPoint(newPos, 20);
		}
		////_x = newPos.x;
		_y = newPos.y;
	}
}
