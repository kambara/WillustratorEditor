import util.*;

class model.Style {
	public var fill:Number;
	public var fillOpacity:Number;
	public var stroke:Number;
	public var strokeWidth:Number;
	public var strokeOpacity:Number;
	
	function Style() {
		fill = 0x000000;
		fillOpacity = 1;
		stroke = null;
		strokeWidth = 1;
		strokeOpacity = 1;
	}
	public static function createFromString(str:String):Style {
		var style = new Style();
		var buf:Array = str.split(";");
		for(var i=0; i<buf.length; i++) {
			if (!buf[i]) {
				continue;
			}
			var prop:Array = buf[i].split(":");
			if (prop.length<2) {
				continue;
			}
			switch(prop[0]) {
				case "fill":
					style.fill = (prop[1] == "none") ? null : ColorName.colorToInt(prop[1]);
					break;
				case "stroke":
					style.stroke = (prop[1] == "none") ? null : ColorName.colorToInt(prop[1]);
					break;
				case "stroke-width":
					style.strokeWidth = parseInt(prop[1]);
					break;
				case "fill-opacity":
					style.fillOpacity = parseFloat(prop[1]);
					break;
				case "stroke-opacity":
					style.strokeOpacity = parseFloat(prop[1]);
					break;
			}
		}
		return style;
	}
	public function clone():Style {
		var s:Style = new Style();
		s.fill = fill;
		s.fillOpacity = fillOpacity;
		s.stroke = stroke;
		s.strokeWidth = strokeWidth;
		s.strokeOpacity = strokeOpacity;
		return s;
	}
	public function toString():String {
		var str = [
			"fill:" + ((fill != null) ? ColorName.intToHtmlColor(fill) : "none"),
			"fill-opacity:" + fillOpacity.toString(),
			"stroke:" + ((stroke != null) ? ColorName.intToHtmlColor(stroke) : "none"),
			"stroke-width:" + strokeWidth.toString(),
			"stroke-opacity:" + strokeOpacity.toString()
		].join(";");
		/*
		var str = "fill:" + ColorName.intToHtmlColor(fill)+";"+
					"fill-opacity:" + fillOpacity.toString()+";"+
					"stroke:" + ColorName.intToHtmlColor(stroke) +";"+
					"stroke-width:" + strokeWidth.toString() +";"+
					"stroke-opacity:" + strokeOpacity.toString();
					*/
		return str;
	}
	public function getFillAlpha():Number {
		return (fill == null) ? 0 : fillOpacity*100;
	}
	public function getStrokeAlpha():Number {
		return (stroke == null) ? 0 : strokeOpacity*100;
	}
}