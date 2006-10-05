class util.SerialNumber {
	private var id:Number;
	function SerialNumber() {
		id = 0;
	}
	function getNumber() {
		return id++;
	}
}