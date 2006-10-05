class UndoBuffer {
	private var buffer:Array;
	private var max:Number;
	private var currentIndex:Number;
	
	function UndoBuffer(max:Number) {
		currentIndex = 0;
		this.max = max;
		buffer = new Array();
	}
	public function addItem(item) {
		if (currentIndex > 0)
			buffer.splice(0, currentIndex);
		buffer.unshift(item);
		currentIndex = 0;
		
		if (buffer.length > max)
			buffer.length = max;
	}
	
	public function undo() {
		if (buffer[currentIndex+1] != undefined) {
			return buffer[increment()];
		} else
			return null;
	}
	public function redo() {
		if (buffer[currentIndex-1] != undefined) {
			return buffer[decrement()];
		} else
			return null;
	}
	
	private function decrement() {
		if (currentIndex > 0)
			currentIndex -= 1;
		else
			currentIndex = 0;
		return currentIndex;
	}
	private function increment() {
		if (currentIndex < buffer.length) {
			currentIndex += 1;
		} else {
			currentIndex = buffer.length;
		}
		return currentIndex;
	}
	
	public function toString() {
		return buffer.toString();
	}
}