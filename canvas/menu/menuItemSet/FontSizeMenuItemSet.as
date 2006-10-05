import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.menuItemSet.FontSizeMenuItemSet extends MenuItemSet {
	private var big:MenuItem;
	private var middle:MenuItem;
	private var small:MenuItem;
	
	function setup() {
		attachMovie("FontSizeBig", "big", 0).init(this,
													  new Point(0, 0));
		attachMovie("FontSizeMiddle", "middle", 1).init(this,
														new Point(big.getRight(), 0));
		attachMovie("FontSizeSmall", "small", 2).init(this,
													new Point(middle.getRight(), 0));
	}
	function onIconClick(name) {
		switch(name) {
			case "big":
				owner.setFontSizeBig();
				break;
			case "middle":
				owner.setFontSizeMiddle();
				break;
			case "small":
				owner.setFontSizeSmall();
				break;
		}
	}
}