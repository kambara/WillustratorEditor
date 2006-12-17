import mx.utils.*;

class property.PanelSet extends mx.core.UIComponent {
	// initObject
	private var main;
	private var shapeModel;
	
	function PanelSet() {
	}
	function init():Void {
		super.init();
		_global.setTimeout(Delegate.create(this, setup), 100);
	}
	function createChildren():Void {
	}
	function setup() {
		// 初期化用 (オーバーライドされる)
	}
}