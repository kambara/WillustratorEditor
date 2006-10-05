import model.*;
import util.*;

class model.Model {
	var text:String;
	var textstyle:TextStyle;
	
	private var modelID:Number;
	public static var serial:SerialNumber = new SerialNumber();
	
	function Model() {
		text = null;
		textstyle = new TextStyle();
		modelID = Model.serial.getNumber();
	}
	public function getID():Number {
		return modelID;
	}
	public function setText(str:String):Void {
		this.text = str;
	}
	public function getText():String {
		return this.text;
	}
	public function getTextStyle():TextStyle {
		return this.textstyle;
	}
	public function getTextMetrics(str) {
		var fmt:TextFormat = new TextFormat();
		fmt.size = textstyle.fontSize;
		if (str) {
			return fmt.getTextExtent(str);
		} else {
			return fmt.getTextExtent(text);
		}
	}
	public function scale(scaleX, scaleY):Void {
		textstyle.fontSize = Math.round(textstyle.fontSize * scaleX);
	}
	private function createXMLElement(name):XMLNode {
		var xml:XML = new XML();
		var elem:XMLNode = xml.createElement(name);
		elem.attributes.textstyle = textstyle.toString();
		if (text && text.length>0) {
			elem.appendChild((new XML()).createTextNode(text));
		}
		return elem;
	}
	/*
	public static function createFromXMLNode(shape:XMLNode):Model {
		var m = new Model();
		if (shape.firstChild && shape.firstChild.nodeType == 3)
			m.text = shape.firstChild.nodeValue;
		m.textstyle = TextStyle.createFromAttr(shape.attributes.textstyle);
		return m;
	}
	*/
}
