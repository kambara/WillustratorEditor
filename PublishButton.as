import mx.controls.Button;

class PublishButton extends Button {
	static var symbolName:String = "PublishButton";
	static var symbolOwner:Object = PublishButton;
	var className:String = "PublishButton";
	
	var main;
	private var receiver:LoadVars;
	private var defaultLabel:String = "Save & Publish (test)";
	
	//
	// TODO:
	// - ボタンを押したときしばらく無効にする
	// - 
	//
	private var publishIntervalId:Number;
	
	function PublishButton() {
	}
	
	function init():Void {
		super.init();
		this.label = defaultLabel;
		setSize(140, 22);
		addEventListener("click", this);
		
		var self = this;
		this.receiver = new LoadVars();
		this.receiver.onData = function(src:String) {
			self.onResponse(src);
		}
	}
	
	function click() {
		this.enabled = false;
		label = "Rasterizing...";
		callLater(500, publish);
	}
	function publish() {
		var bitmapInfo = this.main.getBitmap();
		label = ["Sending... (", Math.round(bitmapInfo.data.length/1000), "KB)"].join("");
		callLater(500, sendToServer, [bitmapInfo]);
	}
	function sendToServer(bitmapInfo) {
		var xml:XML = main.getDocument().getXML();
		var url = main.getPublishUrl();
		var sender = new LoadVars();
		
		sender.xml = xml.toString();
		sender.width = bitmapInfo.width;
		sender.height = bitmapInfo.height;
		sender.data = bitmapInfo.data;
		sender.sendAndLoad(url, this.receiver, "POST");
	}
	function onResponse(src:String) {
		trace("response: " + src);
		if (src && src=="ok") {
			label = "OK";
		} else {
			label = "Error";
		}
		callLater(3000, enable);
	}
	function enable() {
		label = defaultLabel;
		enabled = true;
	}
	private function callLater(msec:Number, func:Function, args:Array) {
		var self = this;
		var intervalId = setInterval(function() {
			clearInterval(intervalId);
			func.apply(self, args);
		}, msec);
	}
}
