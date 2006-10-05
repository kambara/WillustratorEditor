import util.*;
import canvas.menu.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.TextMenu extends Menu {
	var fontSize:FontSizeMenuItemSet;
	var textColor:TextColorMenuItemSet;
	var trash:TrashMenuItem;
	
	private function setup() {
		var serial = new SerialNumber();
		attachMovie("FontSizeMenuItemSet", "fontSize", serial.getNumber()).init(this,
													  new Point(0, 0));
		attachMovie("TextColorMenuItemSet", "textColor", serial.getNumber()).init(this,
																 new Point(0, fontSize.getBottom()));
		attachMovie("TrashMenuItem", "trash", serial.getNumber()).init(
													  this,
													  new Point(0, textColor.getBottom()));
	}
	
	// FontSize
	function setFontSizeBig() {
		model.fontSize = 30;
		canvas.defaultTextFontSize = 30;
		canvas.onSelectMenu();
	}
	function setFontSizeMiddle() {
		model.fontSize = 20;
		canvas.defaultTextFontSize = 20;
		canvas.onSelectMenu();
	}
	function setFontSizeSmall() {
		model.fontSize = 14;
		canvas.defaultTextFontSize = 14;
		canvas.onSelectMenu();
	}
	// TextColor
	function setTextColor(color) {
		model.color = color;
		canvas.defaultTextColor = color;
		canvas.update();
	}
}
