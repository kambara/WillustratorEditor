import model.*;
import util.*;
import flash.geom.*;

class canvas.WillustratorDrawingMC extends AdvancedDrawingMC {
	//
	// Willustator Path
	//
	private function drawFillPath(vertices:Vertices, lineWidth, lineColor, lineAlpha, fillColor, fillAlpha, closepath:Boolean) {
		beginFill(fillColor, fillAlpha);
		drawPathLine(vertices, lineWidth, lineColor, lineAlpha, closepath);
		endFill();
	}
	private function drawPathLine(vertices:Vertices, lineWidth, lineColor, lineAlpha, closepath:Boolean) {
		lineStyle(lineWidth, lineColor, lineAlpha, false, "normal", "square", "miter", 2);
		var start:Point = vertices.getItemAt(0).getAnchor();
		moveTo(start.x, start.y);
		for (var i=1; i<vertices.getLength(); i++) {
			var va:Vertex = vertices.getItemAt(i-1);
			var vb:Vertex = vertices.getItemAt(i);
			edgeTo(va, vb);
		}
		if (closepath) {
			var va:Vertex = vertices.getLastItem();
			var vb:Vertex = vertices.getItemAt(0);
			edgeTo(va, vb);
		}
	}
	private function edgeTo(v1, v2) {
		var p1 = v1.getAnchor();
		var p2 = v2.getAnchor();
		if (v1.getControlB().exist() || v2.getControlA().exist()) {
			var c1 = (v1.getControlB().exist()) ? v1.getControlB().getPoint() : v1.getAnchor();
			var c2 = (v2.getControlA().exist()) ? v2.getControlA().getPoint() : v2.getAnchor();
			bezierTo(p1.x, p1.y, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
		} else {
			lineTo(p2.x, p2.y);
		}
	}
}