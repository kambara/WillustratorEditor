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
	private var fontFamilyComboBox:ComboBox;
	
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
		
		createClassObject(ComboBox, "fontFamilyComboBox", 4, {
			_x: 20,
			_y: 30
		});
		fontFamilyComboBox.setSize(140, fontFamilyComboBox._height);
		
		var fontFamilyItems:Array = ["_sans", "_serif", "_typewriter"].concat(TextField.getFontList().sort());
		
		for (var i=0; i<fontFamilyItems.length; i++) {
			fontFamilyComboBox.addItem(fontFamilyItems[i]);
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
		
		fontFamilyComboBox.addEventListener("focusIn", focusListener);
		fontFamilyComboBox.addEventListener("focusOut", focusListener);
		fontFamilyComboBox.addEventListener("change", {
			change: function(event) {
				var value = event.target.value;
				self.textstyle.fontFamily = value;
				self.main.onPropertyChanged();
			}
		});
	}
	
	public function draw():Void {
		super.draw();
		fontColorLabel.setColor(textstyle.color);
		fontSizeComboBox.text = textstyle.fontSize + "pt";
		fontFamilyComboBox.text = textstyle.fontFamily;
	}
	
	function onSetFocus() {
	}
	function onKillFocus() {
	}
}