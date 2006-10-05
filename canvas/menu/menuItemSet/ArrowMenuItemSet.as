import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.menuItemSet.ArrowMenuItemSet extends MenuItemSet {
	private var arrowBoth:MenuItem;
	private var arrowStart:MenuItem;
	private var arrowEnd:MenuItem;
	private var arrowNone:MenuItem;
	
	function setup() {
		attachMovie("ArrowBoth", "arrowBoth", 0).init(
													  this,
													  new Point(0, 0));
		/*
		attachMovie("ArrowStart", "arrowStart", 1).init(
														this,
														new Point(arrowBoth.getRight(), 0));
		*/
		attachMovie("ArrowEnd", "arrowEnd", 2).init(
													this,
													new Point(arrowBoth.getRight(), 0));
		attachMovie("ArrowNone", "arrowNone", 3).init(
													  this,
													  new Point(arrowEnd.getRight(), 0));
	}
	function onIconClick(name) {
		switch(name) {
			case "arrowBoth":
				owner.setArrowBoth();
				break;
			case "arrowStart":
				owner.setArrowStart();
				break;
			case "arrowEnd":
				owner.setArrowEnd();
				break;
			case "arrowNone":
				owner.setArrowNone();
				break;
		}
	}
}