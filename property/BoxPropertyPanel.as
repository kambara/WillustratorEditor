import util.*;
import property.*;
import mx.controls.*;

class property.BoxPropertyPanel extends PropertyPanel {
	private var figureChoice;
	private var layerProp;
	private var xLabel;
	private var yLabel;
	private var wLabel;
	private var hLabel;
	private var rLabel;
	private var xProp;
	private var yProp;
	private var wProp;
	private var hProp;
	private var rProp;
	private var textStyleProperties;
	private var styleProperties;
	private var layerProperties;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var shapePropOffsetY = 20;
		var posPropOffsetY = 60;
		var rPropOffsetY = 130;
		
		var serial = new SerialNumber();
		
		createClassObject(ComboBox, "figureChoice", serial.getNumber(), {
			fontSize: 14,
			_x: 10,
			_y: shapePropOffsetY
		});
		
		figureChoice.addItem({
			label: "Rect",
			data: "rect"
		});
		figureChoice.addItem({
			label: "Ellipse",
			data: "ellipse"
		});
		
		createClassObject(Label, "xLabel", serial.getNumber(), {
			text: "X:",
			fontSize: 14,
			_x: 10,
			_y: posPropOffsetY
		});
		createClassObject(Label, "yLabel", serial.getNumber(), {
			text: "Y:",
			fontSize: 14,
			_x: 10,
			_y: posPropOffsetY+30
		});
		createClassObject(Label, "wLabel", serial.getNumber(), {
			text: "W:",
			fontSize: 14,
			_x: 100,
			_y: posPropOffsetY
		});
		createClassObject(Label, "hLabel", serial.getNumber(), {
			text: "H:",
			fontSize: 14,
			_x: 100,
			_y: posPropOffsetY+30
		});
		createClassObject(Label, "rLabel", serial.getNumber(), {
			text: "Round:",
			fontSize: 14,
			_x: 10,
			_y: rPropOffsetY
		});
		
		var numStepperScaleX = 70;
		var numStepperFontSize = 14;
		xProp = createClassObject(NumericStepper, "xProp", serial.getNumber(), {
			minimum: -1000,
			maximum: 1000,
			_x: 30,
			_y: posPropOffsetY,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		yProp = createClassObject(NumericStepper, "yProp", serial.getNumber(), {
			minimum: -1000,
			maximum: 1000,
			_x: 30,
			_y: posPropOffsetY+30,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(NumericStepper, "wProp", serial.getNumber(), {
			minimum: 0,
			maximum: 1000,
			_x: 120,
			_y: posPropOffsetY,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(NumericStepper, "hProp", serial.getNumber(), {
			minimum: 0,
			maximum: 1000,
			_x: 120,
			_y: posPropOffsetY+30,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(NumericStepper, "rProp", serial.getNumber(), {
			minimum: 0,
			maximum: 100,
			_x: 70,
			_y: rPropOffsetY,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createObject("StyleProperties", "styleProperties", serial.getNumber(), {
			main: main,
			style: shapeModel.style,
			_x: 10,
			_y: 170
		});
		createObject("TextStyleProperties", "textStyleProperties", serial.getNumber(), {
			main: main,
			textstyle: shapeModel.textstyle,
			_x: 10,
			_y: 270
		});
		createObject("LayerProperties", "layerProperties", serial.getNumber(), {
			main: main,
			length: main.getDocument().getShapeCollection().getLength(),
			_x: 10,
			_y: 300
		});
		
		// set Events
		var self = this;
		figureChoice.addEventListener("change", this);
		xProp.addEventListener("change", this);
		yProp.addEventListener("change", this);
		wProp.addEventListener("change", this);
		hProp.addEventListener("change", this);
		rProp.addEventListener("change", this);
		
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
		if (shapeModel.figure == "rect") {
			figureChoice.selectedIndex = 0;
		} else if (shapeModel.figure == "ellipse") {
			figureChoice.selectedIndex = 1;
		}
		xProp.value = shapeModel.x;
		yProp.value = shapeModel.y;
		wProp.value = shapeModel.width;
		hProp.value = shapeModel.height;
		rProp.value = shapeModel.round;
		textStyleProperties.invalidate();
		styleProperties.invalidate();
		
		layerProperties.value = main.getIndexOfSelectedShape()+1;
	}
	function change(event) {
		shapeModel.figure = figureChoice.value;
		shapeModel.x = xProp.value;
		shapeModel.y = yProp.value;
		shapeModel.width = wProp.value;
		shapeModel.height = hProp.value;
		shapeModel.round = rProp.value;
		main.onPropertyChanged();
	}
}
