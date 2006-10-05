class util.ColorName {
	// 色名変換
	// #FFFFFF, red, 0xFFFFFFといった色名を数値に変換
	//
	public static function colorToInt(c:String):Number {
		// 色と思われる文字列を数値に変換
		// 無効な文字列の場合はnull
		if (!c.length) return null;
		
		if (c.substr(0, 1) == "#") { // HtmlColor
			var i = c.substr(1);
			return parseInt("0x"+i);
		} else if (c.substr(0, 2) == "0x") { // Hex
			return parseInt(c);
		} else {
			return colornameToInt(c);
		}
	}
	static function rgbToInt(r:Number, g:Number, b:Number) {
		var rs:String = r.toString(16);
		if (rs.length==1) rs = "0"+rs;
		var gs:String = g.toString(16);
		if (gs.length==1) gs = "0"+gs;
		var bs:String = b.toString(16);
		if (bs.length==1) bs = "0"+bs;
		var rgbs = "0x"+rs+gs+bs;
		return parseInt(rgbs);
	}
	static function intToHtmlColor(n:Number):String {
		// #つきの文字列に変換
		var s:String = n.toString(16);
		var count = 6-s.length;
		for (var i=0; i<count; i++) {
			s = "0"+s;
		}
		s = s.toUpperCase();
		return "#"+s;
	}
	static function colornameToInt(cname) {
		switch (cname) {
			case "aliceblue": return rgbToInt(240, 248, 255);
			case "antiquewhite": return rgbToInt(250, 235, 215);
			case "aqua": return rgbToInt(0, 255, 255);
			case "aquamarine": return rgbToInt(127, 255, 212);
			case "azure": return rgbToInt(240, 255, 255);
			case "beige": return rgbToInt(245, 245, 220);
			case "bisque": return rgbToInt(255, 228, 196);
			case "black": return rgbToInt(0, 0, 0);
			case "blanchedalmond": return rgbToInt(255, 235, 205);
			case "blue": return rgbToInt(0, 0, 255);
			case "blueviolet": return rgbToInt(138, 43, 226);
			case "brown": return rgbToInt(165, 42, 42);
			case "burlywood": return rgbToInt(222, 184, 135);
			case "cadetblue": return rgbToInt(95, 158, 160);
			case "chartreuse": return rgbToInt(127, 255, 0);
			case "chocolate": return rgbToInt(210, 105, 30);
			case "coral": return rgbToInt(255, 127, 80);
			case "cornflowerblue": return rgbToInt(100, 149, 237);
			case "cornsilk": return rgbToInt(255, 248, 220);
			case "crimson": return rgbToInt(220, 20, 60);
			case "cyan": return rgbToInt(0, 255, 255);
			case "darkblue": return rgbToInt(0, 0, 139);
			case "darkcyan": return rgbToInt(0, 139, 139);
			case "darkgoldenrod": return rgbToInt(184, 134, 11);
			case "darkgray": return rgbToInt(169, 169, 169);
			case "darkgreen": return rgbToInt(0, 100, 0);
			case "darkgrey": return rgbToInt(169, 169, 169);
			case "darkkhaki": return rgbToInt(189, 183, 107);
			case "darkmagenta": return rgbToInt(139, 0, 139);
			case "darkolivegreen": return rgbToInt(85, 107, 47);
			case "darkorange": return rgbToInt(255, 140, 0);
			case "darkorchid": return rgbToInt(153, 50, 204);
			case "darkred": return rgbToInt(139, 0, 0);
			case "darksalmon": return rgbToInt(233, 150, 122);
			case "darkseagreen": return rgbToInt(143, 188, 143);
			case "darkslateblue": return rgbToInt(72, 61, 139);
			case "darkslategray": return rgbToInt(47, 79, 79);
			case "darkslategrey": return rgbToInt(47, 79, 79);
			case "darkturquoise": return rgbToInt(0, 206, 209);
			case "darkviolet": return rgbToInt(148, 0, 211);
			case "deeppink": return rgbToInt(255, 20, 147);
			case "deepskyblue": return rgbToInt(0, 191, 255);
			case "dimgray": return rgbToInt(105, 105, 105);
			case "dimgrey": return rgbToInt(105, 105, 105);
			case "dodgerblue": return rgbToInt(30, 144, 255);
			case "firebrick": return rgbToInt(178, 34, 34);
			case "floralwhite": return rgbToInt(255, 250, 240);
			case "forestgreen": return rgbToInt(34, 139, 34);
			case "fuchsia": return rgbToInt(255, 0, 255);
			case "gainsboro": return rgbToInt(220, 220, 220);
			case "ghostwhite": return rgbToInt(248, 248, 255);
			case "gold": return rgbToInt(255, 215, 0);
			case "goldenrod": return rgbToInt(218, 165, 32);
			case "gray": return rgbToInt(128, 128, 128);
			case "grey": return rgbToInt(128, 128, 128);
			case "green": return rgbToInt(0, 128, 0);
			case "greenyellow": return rgbToInt(173, 255, 47);
			case "honeydew": return rgbToInt(240, 255, 240);
			case "hotpink": return rgbToInt(255, 105, 180);
			case "indianred": return rgbToInt(205, 92, 92);
			case "indigo": return rgbToInt(75, 0, 130);
			case "ivory": return rgbToInt(255, 255, 240);
			case "khaki": return rgbToInt(240, 230, 140);
			case "lavender": return rgbToInt(230, 230, 250);
			case "lavenderblush": return rgbToInt(255, 240, 245);
			case "lawngreen": return rgbToInt(124, 252, 0);
			case "lemonchiffon": return rgbToInt(255, 250, 205);
			case "lightblue": return rgbToInt(173, 216, 230);
			case "lightcoral": return rgbToInt(240, 128, 128);
			case "lightcyan": return rgbToInt(224, 255, 255);
			case "lightgoldenrodyellow": return rgbToInt(250, 250, 210);
			case "lightgray": return rgbToInt(211, 211, 211);
			case "lightgreen": return rgbToInt(144, 238, 144);
			case "lightgrey": return rgbToInt(211, 211, 211);
			case "lightpink": return rgbToInt(255, 182, 193);
			case "lightsalmon": return rgbToInt(255, 160, 122);
			case "lightseagreen": return rgbToInt(32, 178, 170);
			case "lightskyblue": return rgbToInt(135, 206, 250);
			case "lightslategray": return rgbToInt(119, 136, 153);
			case "lightslategrey": return rgbToInt(119, 136, 153);
			case "lightsteelblue": return rgbToInt(176, 196, 222);
			case "lightyellow": return rgbToInt(255, 255, 224);
			case "lime": return rgbToInt(0, 255, 0);
			case "limegreen": return rgbToInt(50, 205, 50);
			case "linen": return rgbToInt(250, 240, 230);
			case "magenta": return rgbToInt(255, 0, 255);
			case "maroon": return rgbToInt(128, 0, 0);
			case "mediumaquamarine": return rgbToInt(102, 205, 170);
			case "mediumblue": return rgbToInt(0, 0, 205);
			case "mediumorchid": return rgbToInt(186, 85, 211);
			case "mediumpurple": return rgbToInt(147, 112, 219);
			case "mediumseagreen": return rgbToInt(60, 179, 113);
			case "mediumslateblue": return rgbToInt(123, 104, 238);
			case "mediumspringgreen": return rgbToInt(0, 250, 154);
			case "mediumturquoise": return rgbToInt(72, 209, 204);
			case "mediumvioletred": return rgbToInt(199, 21, 133);
			case "midnightblue": return rgbToInt(25, 25, 112);
			case "mintcream": return rgbToInt(245, 255, 250);
			case "mistyrose": return rgbToInt(255, 228, 225);
			case "moccasin": return rgbToInt(255, 228, 181);
			case "navajowhite": return rgbToInt(255, 222, 173);
			case "navy": return rgbToInt(0, 0, 128);
			case "oldlace": return rgbToInt(253, 245, 230);
			case "olive": return rgbToInt(128, 128, 0);
			case "olivedrab": return rgbToInt(107, 142, 35);
			case "orange": return rgbToInt(255, 165, 0);
			case "orangered": return rgbToInt(255, 69, 0);
			case "orchid": return rgbToInt(218, 112, 214);
			case "palegoldenrod": return rgbToInt(238, 232, 170);
			case "palegreen": return rgbToInt(152, 251, 152);
			case "paleturquoise": return rgbToInt(175, 238, 238);
			case "palevioletred": return rgbToInt(219, 112, 147);
			case "papayawhip": return rgbToInt(255, 239, 213);
			case "peachpuff": return rgbToInt(255, 218, 185);
			case "peru": return rgbToInt(205, 133, 63);
			case "pink": return rgbToInt(255, 192, 203);
			case "plum": return rgbToInt(221, 160, 221);
			case "powderblue": return rgbToInt(176, 224, 230);
			case "purple": return rgbToInt(128, 0, 128);
			case "red": return rgbToInt(255, 0, 0);
			case "rosybrown": return rgbToInt(188, 143, 143);
			case "royalblue": return rgbToInt(65, 105, 225);
			case "saddlebrown": return rgbToInt(139, 69, 19);
			case "salmon": return rgbToInt(250, 128, 114);
			case "sandybrown": return rgbToInt(244, 164, 96);
			case "seagreen": return rgbToInt(46, 139, 87);
			case "seashell": return rgbToInt(255, 245, 238);
			case "sienna": return rgbToInt(160, 82, 45);
			case "silver": return rgbToInt(192, 192, 192);
			case "skyblue": return rgbToInt(135, 206, 235);
			case "slateblue": return rgbToInt(106, 90, 205);
			case "slategray": return rgbToInt(112, 128, 144);
			case "slategrey": return rgbToInt(112, 128, 144);
			case "snow": return rgbToInt(255, 250, 250);
			case "springgreen": return rgbToInt(0, 255, 127);
			case "steelblue": return rgbToInt(70, 130, 180);
			case "tan": return rgbToInt(210, 180, 140);
			case "teal": return rgbToInt(0, 128, 128);
			case "thistle": return rgbToInt(216, 191, 216);
			case "tomato": return rgbToInt(255, 99, 71);
			case "turquoise": return rgbToInt(64, 224, 208);
			case "violet": return rgbToInt(238, 130, 238);
			case "wheat": return rgbToInt(245, 222, 179);
			case "white": return rgbToInt(255, 255, 255);
			case "whitesmoke": return rgbToInt(245, 245, 245);
			case "yellow": return rgbToInt(255, 255, 0);
			case "yellowgreen": return rgbToInt(154, 205, 50);
			default: return null;
		}
	}
}