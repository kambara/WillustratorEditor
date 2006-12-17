import util.*;

class model.TextStyle {
	var color:Number;
	var fontSize:Number;
	var fontFamily:String;
	
	function TextStyle() {
		color = 0x000000;
		fontSize = 18;
		fontFamily = "_sans";
	}
	public static function createFromAttr(str:String):TextStyle {
		var textstyle = new TextStyle();
		var buf:Array = str.split(";");
		for(var i=0; i<buf.length; i++) {
			if (!buf[i]) continue;
			var prop:Array = buf[i].split(":");
			if (prop.length<2) continue;
			switch(prop[0]) {
				case "color":
					textstyle.color = ColorName.colorToInt(prop[1]);
					break;
				case "font-size":
					textstyle.fontSize = parseInt(prop[1]);
					break;
				case "font-family":
					textstyle.fontFamily = prop[1];
					break;
			}
		}
		return textstyle;
	}
	public function clone():TextStyle {
		var s:TextStyle = new TextStyle();
		s.color = color;
		s.fontSize = fontSize;
		s.fontFamily = fontFamily;
		return s;
	}
	public function toString():String {
		////var str = "color:"+ColorName.intToHtmlColor(color)+";"+
		////			"font-size:"+fontSize.toString();
		return [
			"color:"       + ColorName.intToHtmlColor(color),
			"font-size:"   + fontSize.toString(),
			"font-family:" + fontFamily
		].join(";");
	}
	public function toSVGStyle(align:String):String {
		if (!align) {
			align = "start";
		}
		return [
			"fill:"        + ColorName.intToHtmlColor(color),
			"font-size:"   + (fontSize*72/96).toString() + "pt",
			"text-anchor:" + align,
			"font-family:" + fontFamily
		].join(";");
	}
	/*
	public function getAscent():Number {
		var fmt:TextFormat = new TextFormat();
		fmt.size = fontSize;
		return fmt.getTextExtent("a").ascent;
	}
	public function getLineHeight():Number {
		var fmt:TextFormat = new TextFormat();
		fmt.size = fontSize;
		var metrics = fmt.getTextExtent("a");
		return metrics.ascent + metrics.descent;
	}
	*/
}
