import mx.controls.*;
import mx.utils.*;

class property.StylePropertyPanel extends property.PropertyPanel {
	private var strokeWidthComboBox:ComboBox;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		invalidate();
	}
	public function setup(m, model):Void {
		super.setup(m, model);
		
		var items:Array = ["1", "2", "4", "8", "10", "20", "30"];
		for (var i=0; i<items.length; i++) {
			strokeWidthComboBox.addItem(items[i]);
		}
		strokeWidthComboBox.addEventListener("change", Delegate.create(this, function(event) {
			var value = parseInt(strokeWidthComboBox.value.toString());
			if (!isNaN(value)) {
				shapeModel.style.strokeWidth = value;
			}
			main.onPropertyChanged();
		}));
	}
	public function draw():Void {
		super.draw();
		strokeWidthComboBox.text = shapeModel.style.strokeWidth;
	}
}