import canvas.edit.handle.*;
import util.*;
import flash.geom.*;

class canvas.edit.handle.SizerHorizontalHandle extends Handle {
	private function moveToNewPos(newPos):Void {
		if (owner.isSnapping()) {
			newPos = Snap.snappedPoint(newPos, 20);
		}
		_x = newPos.x;
	}
}
