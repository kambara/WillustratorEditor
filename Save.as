import model.*;

class Save extends MovieClip {
	var main:Main;
	var document:Document;
	var saveUrl:String;
	var sender:LoadVars;
	var receiver:LoadVars;
	
	public function init(main, d, url) {
		this.main = main;
		this.document = d;
		this.saveUrl = url;
		var self = this;
		this.receiver = new LoadVars();
		this.receiver.onLoad = function(success) {
			if (success) {
				self.gotoAndStop("ok");
			} else {
				self.gotoAndStop("error");
			}
		}
	}
	public function setPosition(x, y) {
		_x = x;
		_y = y;
	}
	private function sendXML(xmlStr:String, svgStr:String) {
		sender = new LoadVars();
		sender.xml = xmlStr;
		sender.svg = svgStr;
		trace(xmlStr);
		sender.sendAndLoad(this.saveUrl, this.receiver, "POST");
	}
	function onRelease() {
		if (_currentframe != 1)
			return;
		var xml:XML = document.getXML();
		var svg:XML = document.getSVG();
		sendXML(xml.toString(), svg.toString());
		gotoAndStop("saving");
		
	}
}
