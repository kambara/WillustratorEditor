class SelectedShapes {
	private var shapes:Array();
	
	function SelectedShapes() {
		shapes = new Array();
	}
	public function select(id) {
		shapes = new Array();
		addItem(id);
	}
	public function getList():Array {
		return shapes;
	}
	public function exist():Boolean {
		return (shapes.length>0);
	}
	public function isOne():Boolean {
		return (shapes.length==1);
	}
	public function addItem(id) {
		shapes.push(id);
	}
	public function unselect() {
		shapes = new Array();
	}
}