import mx.utils.*;

class property.BoxPanelSet extends property.PanelSet {
	// modelとmainを受け取る（親クラス）
	var boxPropertyPanel;
	var stylePropertyPanel;
	var textStylePropertyPanel;
	var layerPropertyPanel;
	
	function BoxPanelSet() {
	}
	function init() {
		super.init();
	}
	function createChildren() {
	}
	function setup() {
		// 親クラスから呼ばれる
		// 各Panelを初期化する
		boxPropertyPanel.setup(main, shapeModel);
		stylePropertyPanel.setup(main, shapeModel);
		textStylePropertyPanel.setup(main, shapeModel);
		layerPropertyPanel.setup(main, shapeModel);
	}
	function draw() {
	}
}