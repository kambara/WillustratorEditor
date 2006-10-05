import util.*;
import canvas.menu.menuItem.*;
import canvas.menu.menuItemSet.*;
import flash.geom.*;

class canvas.menu.menuItemSet.LineWidthMenuItemSet extends MenuItemSet {
	private var lineWidthNarrow:MenuItem;
	private var lineWidthWide:MenuItem;
	
	function setup() {
		attachMovie("LineWidthNarrow", "lineWidthNarrow", 0).init(this,
																  new Point(0, 0));
		attachMovie("LineWidthWide", "lineWidthWide", 1).init(this,
															  new Point(lineWidthNarrow.getRight(), 0));
	}
	function onIconClick(name) {
		switch(name) {
			case "lineWidthNarrow":
				owner.setLineWidthNarrow();
				break;
			case "lineWidthWide":
				owner.setLineWidthWide();
				break;
		}
	}
}