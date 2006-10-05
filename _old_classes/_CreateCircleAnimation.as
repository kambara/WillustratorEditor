import util.*;
import canvas.*;

class canvas.CreateCircleAnimation extends AdvancedDrawingMC {
	var owner:Canvas;
	var position:Point;
	var r:Number;
	var intervalID:Number;
	
	function init(owner:Canvas, pos) {
		this.owner = owner;
		position = pos;
		_x = pos.x;
		_y = pos.y;
		r = 0;
		this.intervalID = setInterval(this, "anim", 10);
	}
	function anim() {
		r += 2;
		clear();
		if (r>=50) {
			clearInterval(intervalID);
			owner.onFinishCreateCircleAnimation(position);
			this.removeMovieClip(); // 自己消滅
		} else {
			lineStyle(1, 0x0000FF, 100);
			//beginFill(0xFF0000, 100);
			drawOval(0, 0, r, r);
			//endFill();
			updateAfterEvent();
		}
	}
}