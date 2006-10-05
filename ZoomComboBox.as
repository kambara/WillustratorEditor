import mx.controls.*;
import util.*;

class ZoomComboBox extends mx.core.UIObject {
	// initObj
	private var main:Main;
	
	private var comboBox:ComboBox;
	
	function ZoomComboBox() {
	}
	function init() {
		super.init();
	}
	
	function createChildren() {
		createObject("ComboBox", "comboBox", 0, {
			fontSize: 11,
			textAlign: "center"
		});
		comboBox.setSize(70, 22);
		comboBox.addItem({ label: "50%",  data: 50 });
		comboBox.addItem({ label: "100%", data: 100 });
		comboBox.addItem({ label: "150%", data: 150 });
		comboBox.addItem({ label: "200%", data: 200 });
		comboBox.addItem({ label: "400%", data: 400 });
		comboBox.selectedIndex = 1;
		
		comboBox.addEventListener("change", this);
		
		Stage.addListener(this);
		onResize();
		
		invalidate();
	}
	
	function onResize() {
		_x = StagePosition.getLeft() - 4;
		_y = StagePosition.getBottom() - 18;
	}
	function change() {
		main.onZoomChanged();
	}
	function getValue() {
		return comboBox.value;
	}
}