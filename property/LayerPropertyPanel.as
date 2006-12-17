import mx.controls.*;
import mx.utils.*;

class property.LayerPropertyPanel extends property.PropertyPanel {
	private var layerProp;
	private var denom;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		invalidate();
	}
	public function setup(m, model):Void {
		super.setup(m, model);
		
		layerProp.minimum = 1;
		layerProp.maximum = main.getDocument().getShapeCollection().getLength();
		layerProp.addEventListener("change", Delegate.create(this, function(event) {
			var value = event.target.value;
			if (value && value>0) {
				main.changeLayerOfSelectedShape(value-1);
			}
		}));
	}
	public function draw():Void {
		super.draw();
		layerProp.value = main.getIndexOfSelectedShape()+1;
		denom.text = main.getDocument().getShapeCollection().getLength();
	}
}