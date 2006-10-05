import util.*;
import canvas.edit.handle.*;
import flash.geom.*;

class canvas.edit.Sizer extends AdvancedDrawingMC {
	private var owner;
	private var rect:Rectangle;
	private var originalRect:Rectangle;
	
	private var handleTopLeft:SizerCornerHandle;
	private var handleTopRight:SizerCornerHandle;
	private var handleBottomLeft:SizerCornerHandle;
	private var handleBottomRight:SizerCornerHandle;
	
	private var handleTop:SizerVerticalHandle;
	private var handleBottom:SizerVerticalHandle;
	private var handleLeft:SizerHorizontalHandle;
	private var handleRight:SizerHorizontalHandle;

	function Sizer() {
		rect = new Rectangle();
		
		var serial:SerialNumber = new SerialNumber();
		
		attachMovie("SizerHorizontalHandle", "handleLeft", serial.getNumber()).init(this);
		attachMovie("SizerHorizontalHandle", "handleRight", serial.getNumber()).init(this);
		attachMovie("SizerVerticalHandle", "handleTop", serial.getNumber()).init(this);
		attachMovie("SizerVerticalHandle", "handleBottom", serial.getNumber()).init(this);
		
		attachMovie("SizerCornerHandle", "handleTopLeft", serial.getNumber()).init(this);
		attachMovie("SizerCornerHandle", "handleTopRight", serial.getNumber()).init(this);
		attachMovie("SizerCornerHandle", "handleBottomLeft", serial.getNumber()).init(this);
		attachMovie("SizerCornerHandle", "handleBottomRight", serial.getNumber()).init(this);
		handleTopLeft.setBasicHandle(handleBottomRight);
		handleTopRight.setBasicHandle(handleBottomLeft);
		handleBottomLeft.setBasicHandle(handleTopRight);
		handleBottomRight.setBasicHandle(handleTopLeft);
		update();
	}
	public function init(owner) {
		this.owner = owner;
	}
	private function update() {
		clear();
		drawRectLine(rect.left, rect.top, rect.width, rect.height,
							0, 0x0000FF, 30);
		
		var center = rect.left + rect.width/2;
		handleTop.setPosition(center, rect.top);
		handleBottom.setPosition(center, rect.bottom);
		
		var middle = rect.top + rect.height/2;
		handleLeft.setPosition(rect.left, middle);
		handleRight.setPosition(rect.right, middle);
		
		handleTopLeft.setPosition(rect.left, rect.top);
		handleTopRight.setPosition(rect.right, rect.top);
		handleBottomLeft.setPosition(rect.left, rect.bottom);
		handleBottomRight.setPosition(rect.right, rect.bottom);
		
		var handleScale = 100 * 100/owner.getCanvasScale();
		handleLeft.setScale(handleScale);
		handleRight.setScale(handleScale);
		handleTop.setScale(handleScale);
		handleBottom.setScale(handleScale);
		handleTopLeft.setScale(handleScale);
		handleTopRight.setScale(handleScale);
		handleBottomLeft.setScale(handleScale);
		handleBottomRight.setScale(handleScale);
	}
	
	public function setRectangle(r:Rectangle):Void {
		this.rect = r;
		update();
	}
	public function getRectangle():Rectangle {
		return this.rect;
	}
	public function isSnapping():Boolean { // from SizerCornerHandle
		return owner.isSnapping();
	}
	
	//
	// Handle Event
	//
	public function onHandlePress(h:Handle) {
		originalRect = this.rect.clone();
	}
	public function onHandleStopDrag(h) {
		onHandleDrag(h);
		owner.onSizerChanged(rect, originalRect);
		update();
	}
	public function onHandleDrag(h) {
		var p = h.getPosition();
		switch(h._name) {
			case "handleLeft":
				rect.left = p.x;
				break;
			case "handleRight":
				rect.right = p.x;
				break;
			case "handleTop":
				rect.top = p.y;
				break;
			case "handleBottom":
				rect.bottom = p.y;
				break;
			case "handleTopLeft":
				rect.left = p.x;
				rect.top = p.y;
				break;
			case "handleTopRight":
				rect.right = p.x;
				rect.top = p.y;
				break;
			case "handleBottomLeft":
				rect.left = p.x;
				rect.bottom = p.y;
				break;
			case "handleBottomRight":
				rect.right = p.x;
				rect.bottom = p.y;
				break;
		}
		update();
	}
}