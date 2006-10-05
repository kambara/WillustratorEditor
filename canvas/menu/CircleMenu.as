import util.*;
import canvas.menu.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.CircleMenu extends Menu {
	var lineWidth:LineWidthMenuItemSet;
	var fontSize:FontSizeMenuItemSet;
	var lineColor:LineColorMenuItemSet;
	var fillColor:FillColorMenuItemSet;
	var textColor:TextColorMenuItemSet;
	var trash:TrashMenuItem;
	
	private function setup() {
		var serial = new SerialNumber();
		attachMovie("LineWidthMenuItemSet", "lineWidth", serial.getNumber()).init(this,
													  new Point(0, 0));
		attachMovie("LineColorMenuItemSet", "lineColor", serial.getNumber()).init(this,
																 new Point(0, lineWidth.getBottom()));
		attachMovie("FillColorMenuItemSet", "fillColor", serial.getNumber()).init(this,
																 new Point(0, lineColor.getBottom()));
		
		
		attachMovie("FontSizeMenuItemSet", "fontSize", serial.getNumber()).init(this,
											  new Point(0, fillColor.getBottom()));
		attachMovie("TextColorMenuItemSet", "textColor", serial.getNumber()).init(this,
																 new Point(0, fontSize.getBottom()));
		attachMovie("TrashMenuItem", "trash", serial.getNumber()).init(
													  this,
													  new Point(0, textColor.getBottom()));
	}
	
	// LineWidth
	function setLineWidthNarrow() {
		model.lineWidth = 1;
		canvas.defaultCircleLineWidth = 1;
		canvas.update();
	}
	function setLineWidthWide() {
		model.lineWidth = 5;
		canvas.defaultCircleLineWidth = 5;
		canvas.update();
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

	// LineColor
	function setLineColor(color) {
		model.lineColor = color;
		canvas.defaultCircleLineColor = color;
		canvas.update();
	}
	// FillColor
	function setFillColor(color) {
		model.fillColor = color;
		canvas.defaultCircleFillColor = color;
		canvas.update();
	}
	// TextColor
	function setTextColor(color) {
		model.color = color;
		canvas.defaultCircleColor = color;
		canvas.update();
	}
}
