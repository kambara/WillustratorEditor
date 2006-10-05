import util.*;
import canvas.menu.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.LineMenu extends Menu {
	var lineWidth:LineWidthMenuItemSet;
	var arrow:ArrowMenuItemSet;
	var lineColor:LineColorMenuItemSet;
	var trash:TrashMenuItem;
	
	private function setup() {
		var serial = new SerialNumber();
		attachMovie("LineWidthMenuItemSet", "lineWidth", serial.getNumber()).init(
													  this,
													  new Point(0, 0));
		attachMovie("ArrowMenuItemSet", "arrow", serial.getNumber()).init(
											  this,
											  new Point(0, lineWidth.getBottom()));
		attachMovie("LineColorMenuItemSet", "lineColor", serial.getNumber()).init(
												this,
												new Point(0, arrow.getBottom()));
		attachMovie("TrashMenuItem", "trash", serial.getNumber()).init(
													  this,
													  new Point(0, lineColor.getBottom()));
	}
	
	// LineWidth
	function setLineWidthNarrow() {
		model.lineWidth = 1;
		canvas.defaultLineWidth = 1;
		canvas.update();
	}
	function setLineWidthWide() {
		model.lineWidth = 5;
		canvas.defaultLineWidth = 5;
		canvas.update();
	}
	
	// LineColor
	function setLineColor(color) {
		model.lineColor = color;
		canvas.defaultLineColor = color;
		canvas.update();
	}
	
	// Arrow
	function setArrowBoth() {
		model.arrow = "both";
		canvas.defaultLineArrow = "both";
		canvas.update();
	}
	function setArrowStart() {
		model.arrow = "start";
		canvas.defaultLineArrow = "start";
		canvas.update();
	}
	function setArrowEnd() {
		model.arrow = "end";
		canvas.defaultLineArrow = "end";
		canvas.update();
	}
	function setArrowNone() {
		model.arrow = "none";
		canvas.defaultLineArrow = "none";
		canvas.update();
	}
}
