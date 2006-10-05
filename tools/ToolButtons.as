import util.*;
import tools.*;

class tools.ToolButtons extends MovieClip {
	var selectToolButton;
	var boxToolButton;
	var pathToolButton;
	var textToolButton;
	var freehandToolButton;
	var ellipseToolButton;
	
	public function  init(main) {
		
		attachMovie("SelectToolButton", "selectToolButton", 0).init(main);
		attachMovie("BoxToolButton", "boxToolButton", 1).init(main);
		attachMovie("PathToolButton", "pathToolButton", 2).init(main);
		attachMovie("TextToolButton", "textToolButton", 3).init(main);
		attachMovie("FreehandToolButton", "freehandToolButton", 4).init(main);
		attachMovie("EllipseToolButton", "ellipseToolButton", 5).init(main);
		
		var w = 31;
		var offset = 10;
		var serial = new SerialNumber();
		selectToolButton.setPosition(serial.getNumber() * w, 0);
		boxToolButton.setPosition(serial.getNumber() * w + offset, 0);
		ellipseToolButton.setPosition(serial.getNumber() * w + offset, 0);
		pathToolButton.setPosition(serial.getNumber() * w + offset, 0);
		freehandToolButton.setPosition(serial.getNumber() * w + offset, 0);
		textToolButton.setPosition(serial.getNumber() * w + offset, 0);
		
		update();
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	public function update() {
		selectToolButton.update();
		boxToolButton.update();
		pathToolButton.update();
		textToolButton.update();
		freehandToolButton.update();
		ellipseToolButton.update();
	}
}