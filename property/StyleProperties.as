import property.*;
import util.*;
import mx.controls.*;

class property.StyleProperties extends mx.core.UIObject {
	static var symbolName:String = "property.StyleProperties";
	static var symbolOwner:Object = Object(property.StyleProperties);
 	var className:String = "StyleProperties";

	// initObject
	private var main;
	private var style;
	
	private var fillColorLabel;
	private var fillOpacityLabel;
	private var strokeColorLabel;
	private var strokeOpacityLabel;
	private var strokeWidthComboBox:ComboBox;
	
	function StyleProperties() {
	}
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var serial = new SerialNumber();
		createObject("Label", "label1", serial.getNumber(), {
			text: "Fill :",
			fontSize: 14,
			_x: 0,
			_y: 0
		});
		createObject("Label", "label2", serial.getNumber(), {
			text: "Stroke :",
			fontSize: 14,
			_x: 0,
			_y: 30
		});
		
		attachMovie("ColorPicker", "fillColorLabel", serial.getNumber()).init(60, 0);
		attachMovie("ColorPicker", "strokeColorLabel", serial.getNumber()).init(60, 60);
		
		var numStepperScaleX = 70;
		var numStepperFontSize = 14;
		createClassObject(NumericStepper, "fillOpacityLabel", serial.getNumber(), {
			minimum: 0,
			maximum: 100,
			_x: 90,
			_y: 0,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(ComboBox, "strokeWidthComboBox", serial.getNumber(), {
			_x: 60,
			_y: 30,
			scaleX: 70,
			editable: true,
			fontSize: 14
		});
		var items:Array = [
		  "1px",
		  "2px",
		  "4px",
		  "8px",
		  "10px",
		  "20px",
		  "30px"
		];
		for (var i=0; i<items.length; i++) {
			strokeWidthComboBox.addItem(items[i]);
		}
		createClassObject(NumericStepper, "strokeOpacityLabel", serial.getNumber(), {
			minimum: 0,
			maximum: 100,
			_x: 90,
			_y: 60,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		
		var self = this;
		fillColorLabel.onColorChanged = function() { self.onStylePropertyChanged(); }
		strokeColorLabel.onColorChanged = function() { self.onStylePropertyChanged(); }

		var numStepperListener = {
			focusIn: function() {
				self.onSetFocus();
			},
			focusOut: function() {
				self.onKillFocus();
			},
			change: function() {
				if (self.strokeWidthLabel.value == 1000) {
					self.onEnterFrame = function() {
						self.invalidate();
						delete(self.oEnterFrame);
					}
					return;
				}
				self.style.fillOpacity = self.fillOpacityLabel.value/100;
				self.style.strokeOpacity = self.strokeOpacityLabel.value/100;
		
				self.main.onPropertyChanged();
			}
		};
		fillOpacityLabel.addEventListener("focusIn", numStepperListener);
		fillOpacityLabel.addEventListener("focusOut", numStepperListener);
		fillOpacityLabel.addEventListener("change", numStepperListener);
		strokeOpacityLabel.addEventListener("focusIn", numStepperListener);
		strokeOpacityLabel.addEventListener("focusOut", numStepperListener);
		strokeOpacityLabel.addEventListener("change", numStepperListener);
		
		var focusListener:Object = {
			focusIn: function() {
				self.onSetFocus();
			},
			focusOut: function() {
				self.onKillFocus();
			}
		};
		strokeWidthComboBox.addEventListener("focusIn", focusListener);
		strokeWidthComboBox.addEventListener("focusOut", focusListener);
		strokeWidthComboBox.addEventListener("change", {
			change: function() {
				var value = parseInt(self.strokeWidthComboBox.value);
				self.style.strokeWidth = (isNaN(value)) ? 0 : value;
				self.main.onPropertyChanged();
			}
		});
		
		invalidate();
	}
	public function draw():Void {
		super.draw();
		fillColorLabel.setColor(style.fill);
		strokeColorLabel.setColor(style.stroke);

		fillOpacityLabel.value = style.fillOpacity*100;
		strokeOpacityLabel.value = style.strokeOpacity*100;
		
		strokeWidthComboBox.text = style.strokeWidth + "px";
	}
	
	function onSetFocus() { // 外部から書き換え
	}
	function onKillFocus() { // 外部から書き換え
	}
	public function onStylePropertyChanged():Void {
		style.fill = fillColorLabel.getColor();
		style.stroke = strokeColorLabel.getColor();
		
		main.onPropertyChanged();
	}
}