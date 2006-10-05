import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*

class canvas.menu.menuItemSet.TextColorMenuItemSet extends MenuItemSet {
	private var textColorA:TextColorMenuItem;
	private var textColorB:TextColorMenuItem;
	private var textColorC:TextColorMenuItem;
	
	function setup() {
		attachMovie("TextColorMenuItem", "textColorA", 0).init(
															   owner,
															   new Point(0, 0),
															   0x000000);
		attachMovie("TextColorMenuItem", "textColorB", 1).init(
															   owner,
															   new Point(textColorA.getRight(), 0),
															   0xFF0000);
		attachMovie("TextColorMenuItem", "textColorC", 2).init(
															   owner,
															   new Point(textColorB.getRight(), 0),
															   0xFFFFFF);
	}
}