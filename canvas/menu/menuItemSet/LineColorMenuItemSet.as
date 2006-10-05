import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.menuItemSet.LineColorMenuItemSet extends MenuItemSet {
	private var lineColorA:LineColorMenuItem;
	private var lineColorB:LineColorMenuItem;
	private var lineColorC:LineColorMenuItem;
	
	function setup() {
		attachMovie("LineColorMenuItem", "lineColorA", 0).init(
															   owner,
															   new Point(0, 0),
															   0x000000);
		attachMovie("LineColorMenuItem", "lineColorB", 1).init(
															   owner,
															   new Point(lineColorA.getRight(), 0),
															   0xFF0000);
		attachMovie("LineColorMenuItem", "lineColorC", 2).init(
															   owner,
															   new Point(lineColorB.getRight(), 0),
															   0x0000FF);
	}
}