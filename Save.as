import model.*;

class Save extends MovieClip {
	var document:Document;
	var saveUrl:String;
	var sender:LoadVars;
	var receiver:LoadVars;
	
	public function init(d, url) {
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
		sender.sendAndLoad(this.saveUrl, this.receiver, "POST");
	}
	function onRelease() {
		if (_currentframe != 1)
			return;
		var xml:XML = document.getXML();
		var svg:XML = document.getSVG();
		trace(xml.toString());
		trace(svg.toString());
		sendXML(xml.toString(), svg.toString());
		gotoAndStop("saving");
	}
}
