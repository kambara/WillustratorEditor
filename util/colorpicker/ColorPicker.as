import util.*;
import util.colorpicker.*;
import mx.managers.DepthManager;

class util.colorpicker.ColorPicker extends AdvancedDrawingMC {
	private var color:Number;
	private var colorPickerPopup;
	
	public function init(x, y):Void {
		_x = x;
		_y = y;
	}
	private function draw():Void {
		clear();
		/*
		drawFillRect(0, 0, 20, 20,
					  1, 0x000000, 100,
					  this.color, 100);
		*/
		var fillColor = (this.color == undefined) ? 0xFFFFFF : this.color;
		drawFillRect(0, 0, 20, 20,
					  1, 0x000000, 100,
					  fillColor, 100);
	}
	public function setColor(c:Number):Void {
		this.color = c;
		draw();
	}
	public function getColor():Number {
		return (this.color == undefined) ? null : this.color;
	}
	function onPress() {
		var p = {x:0, y:20};
		this.localToGlobal(p);
		//var d = _root.getNextHighestDepth();
		/*
		var d = 1000;
		_root.attachMovie("ColorPickerPopup", "colorPicker", d).init(this, p.x, p.y);
		*/
		this.colorPickerPopup = _root.createChildAtDepth("ColorPickerPopup", DepthManager.kTop);
		this.colorPickerPopup.init(this, p.x, p.y);
	}
	public function onColorPick(c) {
		//_root.colorPicker.removeMovieClip();
		colorPickerPopup.unloadMovie();
		
		setColor(c);
		onColorChanged();
	}
	function onColorChanged() {
	}
}
