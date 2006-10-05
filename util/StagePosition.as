class util.StagePosition {
	static public function getLeft() {
		return -(Stage.width-600)/2;
	}
	static public function getRight() {
		return getLeft() + Stage.width;
	}
	static public function getTop() {
		return -(Stage.height-400)/2;
	}
	static public function getBottom() {
		return getTop() + Stage.height;
	}
}