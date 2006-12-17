import util.*;
import property.*;
import mx.controls.*;

class property.TextPropertyPanel extends PropertyPanel {
	private var xLabel;
	private var yLabel;
	private var xProp;
	private var yProp;
	private var textStyleProperties;
	private var layerProperties;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var serial = new SerialNumber();
		
		createClassObject(Label, "xLabel", serial.getNumber(), {
			text: "X :",
			fontSize: 14,
			_x: 10,
			_y: 20
		});
		createClassObject(Label, "yLabel", serial.getNumber(), {
			text: "Y :",
			fontSize: 14,
			_x: 10,
			_y: 50
		});
		
		var numStepperScaleX = 70;
		var numStepperFontSize = 14;
		createClassObject(NumericStepper, "xProp", serial.getNumber(), {
			minimum: -1000,
			maximum: 1000,
			_x: 30,
			_y: 20,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(NumericStepper, "yProp", serial.getNumber(), {
			minimum: -1000,
			maximum: 1000,
			_x: 30,
			_y: 50,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		
		createObject("TextStyleProperties", "textStyleProperties", serial.getNumber(), {
			main: main,
			textstyle: shapeModel.textstyle,
			_x: 10,
			_y: 90
		});
		
		createObject("LayerProperties", "layerProperties", serial.getNumber(), {
			main: main,
			length: main.getDocument().getShapeCollection().getLength(),
			_x: 10,
			_y: 150
		});
		
		// set events
		var self = this;
		xProp.addEventListener("change", this);
		yProp.addEventListener("change", this);
		
		var layerPropListener = new Object();
		layerPropListener.change = function(event) {
			var v = event.target.value;
			if (v && v>0) {
				self.main.changeLayerOfSelectedShape(v-1);
			}
		}
		layerProperties.addEventListener("change", layerPropListener);
		
		invalidate();
	}
	
	public function draw():Void {
		super.draw();
		xProp.value = shapeModel.x;
		yProp.value = shapeModel.y;
		textStyleProperties.invalidate();
		layerProperties.value = main.getIndexOfSelectedShape()+1;
	}
	
	public function change():Void {
		shapeModel.x = xProp.value;
		shapeModel.y = yProp.value;
		main.onPropertyChanged();
	}
}
