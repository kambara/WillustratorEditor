import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.menuItemSet.FillColorMenuItemSet extends MenuItemSet {
	private var fillColorA:FillColorMenuItem;
	private var fillColorB:FillColorMenuItem;
	private var fillColorC:FillColorMenuItem;
	
	function setup() {
		attachMovie("FillColorMenuItem", "fillColorA", 0).init(
															   owner,
															   new Point(0, 0),
															   0x0000FF);
		attachMovie("FillColorMenuItem", "fillColorB", 1).init(
															   owner,
															   new Point(fillColorA.getRight(), 0),
															   0xFFFFFF);
		attachMovie("FillColorMenuItem", "fillColorC", 2).init(
															   owner,
															   new Point(fillColorB.getRight(), 0),
															   0xFF0000);
	}
}