import mx.controls.*;
import mx.utils.*;

class property.TextStylePropertyPanel extends property.PropertyPanel {
	private var fontSizeComboBox:ComboBox;
	private var fontFamilyComboBox:ComboBox;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		invalidate();
	}
	public function setup(m, model):Void {
		super.setup(m, model);
		
		var items:Array = ["12", "16", "20", "30", "50"];
		for (var i=0; i<items.length; i++) {
			fontSizeComboBox.addItem(items[i]);
		}
		fontSizeComboBox.addEventListener("change", Delegate.create(this, function(event) {
			var value = parseInt(event.target.value);
			shapeModel.getTextStyle().fontSize = (isNaN(value)) ? 0 : value;
			main.onPropertyChanged();
		}));
		
		var fontFamilyItems:Array = ["_sans", "_serif", "_typewriter"].concat(TextField.getFontList().sort());
		for (var i=0; i<fontFamilyItems.length; i++) {
			fontFamilyComboBox.addItem(fontFamilyItems[i]);
		}
		fontFamilyComboBox.addEventListener("change", Delegate.create(this, function(event) {
			shapeModel.getTextStyle().fontFamily = event.target.value;
			main.onPropertyChanged();
		}));
	}
	public function draw():Void {
		super.draw();
		////fontColorLabel.setColor(textstyle.color);
		fontSizeComboBox.text = shapeModel.getTextStyle().fontSize;
		fontFamilyComboBox.text = shapeModel.getTextStyle().fontFamily;
	}
}