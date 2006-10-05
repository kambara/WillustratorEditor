import util.*;
import model.*;
import flash.geom.*;

interface model.IShapeModel {
	function getShapeType():String;
	function getID():Number;
	public function move(d):Void;
	public function scale(scaleX, scaleY):Void
	public function setText(str:String):Void;
	public function getText():String;
	public function getTextStyle():TextStyle;
	public function getTextPosition():Point;
	public function getTextAlign():String;
	public function getTextVAlign():String;
	public function getLeft():Number;
	public function getRight():Number;
	public function getTop():Number;
	public function getBottom():Number;
	public function getRectangle():Rectangle;
	public function clone():IShapeModel;
	public function intersects(rect:Rectangle):Boolean;
	
	////function isDiscarded():Boolean;
	////function getDiscardedTime():String
	////function discard():Void;
	
	public function getXMLNode():XMLNode;
	public function getSVGNode():XMLNode;
}
