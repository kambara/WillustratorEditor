import util.*;
import property.*;
import mx.controls.*;

class property.BoxToolPropertyPanel extends PropertyPanel {
	private var figureChoice;
	//private var rProp;
	//private var styleProperties;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var shapePropOffsetY = 20;
		
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
		
		/***
		createClassObject(Label, "rLabel", serial.getNumber(), {
			text: "Round:",
			fontSize: 14,
			_x: 10,
			_y: rPropOffsetY
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
		*/
		
		// set Events
		var self = this;
		figureChoice.addEventListener("change", this);
		//rProp.addEventListener("change", this);
		invalidate();
	}
	public function draw():Void {
		super.draw();
		/*
		if (shapeModel.figure == "rect") {
			figureChoice.selectedIndex = 0;
		} else if (shapeModel.figure == "ellipse") {
			figureChoice.selectedIndex = 1;
		}
		*/
		/*
		rProp.value = shapeModel.round;
		textStyleProperties.invalidate();
		styleProperties.invalidate();
		*/
		////layerProperties.value = main.getIndexOfSelectedShape()+1;
	}
	public function getFigureType() {
		return figureChoice.value;
	}
	function change(event) {
		//shapeModel.figure = figureChoice.value;
		/*
		shapeModel.round = rProp.value;
		main.onPropertyChanged();
		*/
	}
}
