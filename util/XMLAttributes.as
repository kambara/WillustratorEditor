import util.*;

class util.XMLAttributes {
	var attr:Object = null;
	function XMLAttributes(attr:Object) {
		this.attr = attr;
	}
	function getStringParam(name) {
		return (attr[name]) ? attr[name] : null;
	}
	function getIntParam(name) {
		return (attr[name]) ? parseInt(attr[name]) : null;
	}
	function getColorParam(name) {
		return (attr[name]) ? ColorName.colorToInt(attr[name]) : null;
	}
}