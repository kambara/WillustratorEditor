import util.*;
import model.*;
import canvas.shape.*;
import flash.geom.*;

class canvas.shape.Box extends Shape {
	private var textlabel:TextLabel;
	private var backgroundImage:MovieClip;
	private var mask:MovieClip;
	private var loadedSrc:String;
	
	function Box() {
		attachMovie("TextLabel", "textlabel", 10).init();
	}
	function draw():Void {
		clear();
		drawBackgroundImage();
		if (shapeModel.figure == "rect") {
			drawBoxRect();
		} else if (shapeModel.figure == "ellipse") {
			drawBoxEllipse();
		}
		drawText();
	}
	private function drawWhileDragging(d:Point):Void {
		draggingFrame.clear();
		draggingFrame.drawRectLine(shapeModel.x+d.x, shapeModel.y+d.y, shapeModel.width, shapeModel.height,
												1, 0x000000, 100);
	}
	
	private function loadBackgroundImage() {
		backgroundImage = createEmptyMovieClip("backgroundImage", 0);
		backgroundImage._quality = "BEST";
		var img = backgroundImage;
		var w = shapeModel.width;
		var h = shapeModel.height;
		var mcLoader:MovieClipLoader = new MovieClipLoader();
		mcLoader.addListener({
			onLoadError: function() {
				trace("load error");
			},
			onLoadInit: function() {
				img._width = w;
				img._height = h;
			}
		});
		mcLoader.loadClip(shapeModel.getSrc(), backgroundImage);
	}
	private function drawBackgroundImage() {
		if (!shapeModel.getSrc()) return;
		// 必要なら読み込む
		if (loadedSrc != shapeModel.getSrc()) {
			loadedSrc = shapeModel.getSrc();
			loadBackgroundImage();
		}
		
		// 画像サイズ・位置
		backgroundImage._x = shapeModel.x;
		backgroundImage._y = shapeModel.y;
		if (backgroundImage._width && backgroundImage._height) {
			backgroundImage._width = shapeModel.width;
			backgroundImage._height = shapeModel.height;
		}
		
		// マスク
		if (!mask) {
			mask = attachMovie("WillustratorDrawingMC", "mask", 1);
		}
		mask.clear();
		if (shapeModel.figure == "rect") {
			mask.drawFillRoundRect(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
								 shapeModel.round, shapeModel.round,
								 1, 0x000000, 100,
								 0x000000, 100);
		} else if (shapeModel.figure == "ellipse") {
			var rx = shapeModel.width/2;
			var ry = shapeModel.height/2;
			var cx = shapeModel.x + rx;
			var cy = shapeModel.y + ry;
			mask.drawFillOval(cx, cy, rx, ry,
							 1, 0x000000, 100,
							 0x000000, 100);
		}
		backgroundImage.setMask(mask);
	}
	private function drawBoxRect() {
		if (shapeModel.style.getFillAlpha()>0 || shapeModel.style.fill != null) { // 塗りがあるとき
			drawFillRoundRect(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 shapeModel.style.strokeWidth, shapeModel.style.stroke,
									 shapeModel.style.getStrokeAlpha(),
									 shapeModel.style.fill,
									 shapeModel.style.getFillAlpha());
		} else { // 塗りがないとき
			// 透明の太い線 (選択用)
			drawRoundRectLine(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 10, 0x000000, 0);
			drawRoundRectLine(shapeModel.x, shapeModel.y, shapeModel.width, shapeModel.height,
									 shapeModel.round, shapeModel.round,
									 shapeModel.style.strokeWidth, shapeModel.style.stroke,
									 shapeModel.style.getStrokeAlpha());
		}
	}
	private function drawBoxEllipse() {
		var rx = shapeModel.width/2;
		var ry = shapeModel.height/2;
		var cx = shapeModel.x + rx;
		var cy = shapeModel.y + ry;
		if (shapeModel.style.getFillAlpha() > 0 || shapeModel.style.fill != null) {
			drawFillOval(cx, cy, rx, ry,
						 shapeModel.style.strokeWidth,
						 shapeModel.style.stroke,
						 shapeModel.style.getStrokeAlpha(),
						 shapeModel.style.fill,
						 shapeModel.style.getFillAlpha());
		} else {
			drawOvalLine(cx, cy, rx, ry,
						 10, 0x000000, 0);
			drawOvalLine(cx, cy, rx, ry,
						 shapeModel.style.strokeWidth,
						 shapeModel.style.strokeColor,
						 shapeModel.style.getStrokeAlpha());
		}
	}
	private function drawText() {
		textlabel.setProperties(shapeModel.text,
							shapeModel.x + shapeModel.width/2,
							shapeModel.y + shapeModel.height/2,
							shapeModel.textstyle.color,
							shapeModel.textstyle.fontSize,
							"center", "middle",
							shapeModel.textstyle.fontFamily);
	}
}