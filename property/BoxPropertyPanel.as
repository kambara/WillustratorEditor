import util.*;
import property.*;
import mx.controls.*;
import mx.utils.*;

class property.BoxPropertyPanel extends PropertyPanel {
	private var xProp;
	private var yProp;
	private var wProp;
	private var hProp;
	private var rProp;
	private var figureChoice:ComboBox;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		/***
		var layerPropListener = new Object();
		layerPropListener.change = function(event) {
			var v = event.target.value;
			if (v && v>0) {
				self.main.changeLayerOfSelectedShape(v-1);
			}
		}
		layerProperties.addEventListener("change", layerPropListener);
		***/
		invalidate();
	}
	public function setup(m, model):Void {
		super.setup(m, model);
		
		// 色々初期化する
		var max = 1000;
		var min = -1000;
		
		xProp.minimum = min;
		xProp.maximum = max;
		yProp.minimum = min;
		yProp.maximum = max;
		wProp.minimum = min;
		wProp.maximum = max;
		hProp.minimum = min;
		hProp.maximum = max;
		rProp.minimum = 0;
		rProp.maximum = 100;
		
		xProp.addEventListener("change", this);
		yProp.addEventListener("change", this);
		wProp.addEventListener("change", this);
		hProp.addEventListener("change", this);
		rProp.addEventListener("change", this);
		figureChoice.addEventListener("change", this);
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
		
		////layerProperties.value = main.getIndexOfSelectedShape()+1;
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
