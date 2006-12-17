import util.*;
import model.*;
import canvas.layer.*;
import flash.geom.*;

class TextEditLayer extends Layer {
	private var textLabel:EditableTextLabel;
	private var shapeModel:IShapeModel;
	
	public function startEdit(m) {
		this.shapeModel = m;
		finishEdit();
		
		attachMovie("EditableTextLabel", "textLabel", 0).init();
		var pos:Point = m.getTextPosition();
		textLabel.setProperties(m.getText(), pos.x, pos.y,
										  0x000000,
										  m.getTextStyle().fontSize,
										  m.getTextAlign(), m.getTextVAlign(),
										  m.getTextStyle().fontFamily);
		var self = this;
		textLabel.onChanged = function() {
			self.onTextChanged();
		};
		textLabel.onKillFocus = function() {
			self.onTextKillFocus();
		};
	}
	private function onTextChanged() {
	}
	private function onTextKillFocus() {
		if (!textLabel._visible) return;
		
		if (textLabel.getText() == ""
			&& shapeModel.getShapeType()==ShapeType.text) {
			// TextLabelならモデルごと削除
			////main.deleteModel(shapeModel);
			main.removeSelectedShapes();
		} else {
			shapeModel.setText(textLabel.getText());
		}
		main.onEditChanged();
		textLabel._visible = false;
	}
	public function finishEdit() {
		textLabel.removeMovieClip();
		textLabel.unloadMovie();
	}
	public function isEditing():Boolean {
		return (textLabel) ? true : false;
	}
}