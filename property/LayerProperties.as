import property.*;
import util.*;
import mx.controls.*;

class property.LayerProperties extends mx.core.UIObject {
	static var symbolName:String = "property.LayerProperties";
	static var symbolOwner:Object = Object(property.LayerProperties);
 	var className:String = "LayerProperties";

	// initObject
	private var main;
	private var length;
	
	private var label;
	private var layerProp;
	private var denomLabel;
	
	function LayerProperties() {
	}
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var serial = new SerialNumber();
		createObject("Label", "label", serial.getNumber(), {
			text: "Layer :",
			fontSize: 14,
			_x: 0,
			_y: 0
		});
		if (length) {
			createObject("Label", "denomLabel", serial.getNumber(), {
				text: "/ "+length.toString(),
				fontSize: 14,
				_x: 120,
				_y: 0
			});
		}
		var numStepperScaleX = 70;
		var numStepperFontSize = 14;
		createClassObject(NumericStepper, "layerProp", serial.getNumber(), {
			minimum: 1,
			maximum: length,
			_x: 60,
			_y: 0,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		layerProp.addEventListener("focusIn", this);
		layerProp.addEventListener("focusOut", this);
		layerProp.addEventListener("change", this);
		
		invalidate();
	}
	public function draw():Void {
		super.draw();
	}
	
	function focusIn() {
		dispatchEvent({type: "focusIn"});
	}
	function focusOut() {
		dispatchEvent({type: "focusIn"});
	}
	function change() {
		dispatchEvent({type: "change"});
	}
	
	public function get value():Number {
		return layerProp.value;
	}
	public function set value(n:Number) {
		layerProp.value = n;
	}
}