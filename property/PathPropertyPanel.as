import util.*;
import property.*;
import mx.controls.RadioButton;
import mx.controls.Label;

class property.PathPropertyPanel extends PropertyPanel {
	private var closeRadioButton;
	private var openRadioButton;
	private var textStyleProperties;
	private var styleProperties;
	private var layerProperties;
	
	private var editTypeLabel:Label;
	private var editPathRadioButton;
	private var editSizeRadioButton;
	
	
	public function init():Void {
		super.init();
	}
	
	public function createChildren():Void {
		var closePropOffsetY = 20;
		
		var serial = new SerialNumber();
		createClassObject(RadioButton, "openRadioButton", serial.getNumber(), {
			label: "Open",
			data: "open",
			groupName: "endPathChoice",
			fontSize: 14,
			_x: 10,
			_y: closePropOffsetY
		});
		createClassObject(RadioButton, "closeRadioButton", serial.getNumber(), {
			label: "Close Path",
			data: "close",
			groupName: "endPathChoice",
			fontSize: 14,
			_x: 80,
			_y: closePropOffsetY
		});
		createObject("StyleProperties", "styleProperties", serial.getNumber(), {
			main: main,
			style: shapeModel.style,
			_x: 10,
			_y: 60
		});
		createObject("TextStyleProperties", "textStyleProperties", serial.getNumber(), {
			main: main,
			textstyle: shapeModel.textstyle,
			_x: 10,
			_y: 160
		});
		
		createObject("LayerProperties", "layerProperties", serial.getNumber(), {
			main: main,
			length: main.getDocument().getShapeCollection().getLength(),
			_x: 10,
			_y: 230
		});
		
		createObject("Label", "editTypeLabel", serial.getNumber(), {
			text: "Edit :",
			fontSize: 14,
			_x: 10,
			_y: 270
		});
		createClassObject(RadioButton, "editPathRadioButton", serial.getNumber(), {
			label: "Path",
			data: "path",
			groupName: "editTypeChoice",
			fontSize: 14,
			_x: 70,
			_y: 270
		});
		createClassObject(RadioButton, "editSizeRadioButton", serial.getNumber(), {
			label: "Size",
			data: "size",
			groupName: "editTypeChoice",
			fontSize: 14,
			_x: 130,
			_y: 270
		});
		editPathRadioButton.selected = true;
		
		
		var self = this;
		openRadioButton.addEventListener("click", this);
		closeRadioButton.addEventListener("click", this);
		
		var layerPropListener = {
			change: function(event) {
				var v = event.target.value;
				if (v && v>0) {
					self.main.changeLayerOfSelectedShape(v-1);
				}
			}
		}
		layerProperties.addEventListener("change", layerPropListener);
		
		
		var editTypeListener = {
			click: function(event) {
				var type = event.target.data;
				self.main.changeEditType(type);
			}
		}
		editPathRadioButton.addEventListener("click", editTypeListener);
		editSizeRadioButton.addEventListener("click", editTypeListener);
		
		invalidate();
	}
	
	public function draw():Void {
		super.draw();
		if (shapeModel.closepath) {
			closeRadioButton.selected = true;
		} else {
			openRadioButton.selected = true;
		}
		textStyleProperties.invalidate();
		styleProperties.invalidate();
		layerProperties.value = main.getIndexOfSelectedShape()+1;
	}
	
	public function click(event) {
		if (event.target.groupName
			  && event.target.groupName=="endPathChoice") {
			var endPath = event.target.data;
			shapeModel.closepath = (endPath=="close");
		}
		main.onPropertyChanged();
	}
}
