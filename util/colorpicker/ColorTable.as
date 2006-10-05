import util.colorpicker.*;

class util.colorpicker.ColorTable extends MovieClip {
	private var cellw:Number = 10;
	private var owner;
	
	public function init(owner):Void {
		this.owner = owner;
		createTable();
	}
	private function createTable() {
		for (var m=0; m<=1; m++) { // 上段・下段 (Rが前後半)
			for (var k=0; k<6; k++) { // 行 (Bが変化)
				var b = (3*k).toString(16);
				for (var j=0; j<3; j++) { // Rが変化
					var r = (3*j + 9*m).toString(16);
					for (var i=0; i<6; i++) { // Gが変化
						var g = (3*i).toString(16);
						var c = parseInt("0x"+r+r+g+g+b+b);
						var column = i + 6*j;
						var row = k + 6*m;
						var x = column * cellw;
						var y = row * cellw;
						var cellname = "cell_"+row+"_"+column;
						attachMovie("ColorPickerCell", cellname, getNextHighestDepth()).init(c, x, y, cellw, this.owner);
					}
				}
			}
		}
		// グレースケール
		for (var i:Number=0; i<16; i++) {
			var h = i.toString(16);
			var c = parseInt("0x"+h+h+h+h+h+h);
			var x = i * cellw;
			var y = 12 * cellw;
			var cellname = "gray_"+i.toString(16);
			attachMovie("ColorPickerCell", cellname, getNextHighestDepth()).init(c, x, y, cellw, owner);
		}
	}
}