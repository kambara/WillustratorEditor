import property.*;
import mx.controls.*;

class property.TextStyleProperties extends mx.core.UIObject {
	static var symbolName:String = "property.TextStyleProperties";
	static var symbolOwner:Object = Object(property.TextStyleProperties);
 	var className:String = "TextStyleProperties";
	
	// initObject
	private var main;
	private var textstyle;
	
	private var fontColorLabel;
	private var fontSizeComboBox:ComboBox;
	
	function TextStyleProperties() {
	}
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		createClassObject(Label, "label", 0, {
			text: "Text:",
			fontSize: 14,
			_x: 0,
			_y: 0
		});
		attachMovie("ColorPicker", "fontColorLabel", 1).init(60, 0);
		
		createClassObject(ComboBox, "fontSizeComboBox", 3, {
			_x: 90,
			_y: 0,
			scaleX: 70,
			editable: true,
			fontSize: 14
		});
		var items:Array = [
		  "12pt",
		  "16pt",
		  "20pt",
		  "30pt",
		  "50pt"
		];
		for (var i=0; i<items.length; i++) {
			fontSizeComboBox.addItem(items[i]);
		}
		
		//
		// Events
		//
		var self = this;
		fontColorLabel.onColorChanged = function() {
			self.textstyle.color = self.fontColorLabel.getColor();
			self.main.onPropertyChanged();
		}
		
		var focusListener:Object = {
			focusIn: function() {
				self.onSetFocus();
			},
			focusOut: function() {
				self.onKillFocus();
			}
		};
		fontSizeComboBox.addEventListener("focusIn", focusListener);
		fontSizeComboBox.addEventListener("focusOut", focusListener);
		fontSizeComboBox.addEventListener("change", {
			change: function(event) {
				var value = parseInt(event.target.value);
				self.textstyle.fontSize = (isNaN(value)) ? 0 : value;
				self.main.onPropertyChanged();
			}
		});
	}
	public function draw():Void {
		super.draw();
		fontColorLabel.setColor(textstyle.color);
		fontSizeComboBox.text = textstyle.fontSize + "pt";
	}
	
	function onSetFocus() {
	}
	function onKillFocus() {
	}
}