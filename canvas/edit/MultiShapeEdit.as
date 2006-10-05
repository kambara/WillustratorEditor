import util.*;
import canvas.*;
import canvas.edit.*;
import canvas.edit.handle.*;
import flash.geom.*;

class canvas.edit.MultiShapeEdit extends ShapeEdit {
	private var shapeCollection;
	private var sizer:Sizer;
	
	public function init(sc, main, editLayer) {
		this.shapeCollection = sc;
		this.main = main;
		this.editLayer = editLayer;
		createChildren();
		draw();
		Key.addListener(this);
	}
	public function createChildren():Void {
		attachMovie("Sizer", "sizer", 0).init(this);
	}
	public function draw() {
		sizer.setRectangle(shapeCollection.getRectangle());
	}
	public function update():Void { // EditLayerから呼ばれるので残し
		draw();
	}
	
	//
	// Sizer Event
	//
	public function onSizerChanged(rect:Rectangle, originalRect:Rectangle) {
		var scaleX = rect.width / originalRect.width;
		var scaleY = rect.height / originalRect.height;
		
		// scale
		var offset:Point = shapeCollection.getRectangle().topLeft;
		shapeCollection.move(new Point(-offset.x, -offset.y));
		shapeCollection.scale(scaleX, scaleY);
		shapeCollection.move(offset);

		// move
		var d:Point = rect.topLeft.subtract(originalRect.topLeft);
		shapeCollection.move(d);
		
		main.onEditChanged();
		draw(); // for update sizer
	}
}