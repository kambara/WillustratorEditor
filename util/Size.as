class util.Size {
	public var width:Number;
	public var height:Number;
	
	function Size(w:Number, h:Number) {
		this.width = w;
		this.height = h;
	}
	function clone() {
		return new Size(width, height);
	}
	function toString() {
		return width.toString()+","+height.toString();
	}
}
