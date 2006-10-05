import util.*;

class util.colorpicker.ColorPickerPopup extends MovieClip {
	private var label;
	public function init(label, x, y):Void {
		this.label = label;
		_x = x;
		_y = y;
		attachMovie("ColorTable", "colorTable", 0).init(this);
		// 位置調整
		if (this._x+this._width > StagePosition.getRight()) {
			this._x = StagePosition.getRight()-this._width;
		}
		if (this._y+this._height > StagePosition.getBottom()) {
			this._y = StagePosition.getBottom()-this._height;
		}
	}
	public function onPick(c) {
		label.onColorPick(c);
	}
	public function onCellOver(c) {
	}
	public function onCellOut(c) {
	}
	function onMouseDown() {
		if ( !this.hitTest(_root._xmouse, _root._ymouse, true) ) {
			//this.removeMovieClip();
			this.unloadMovie();
		}
	}
}
