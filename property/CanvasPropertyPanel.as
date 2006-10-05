import util.*;
import property.*;
import mx.controls.*;
import mx.containers.*;
import mx.managers.PopUpManager;

class property.CanvasPropertyPanel extends PropertyPanel {
	private var wLabel;
	private var hLabel;
	private var wProp;
	private var hProp;
	private var canvasColorPicker;
	private var snapCheckBox:CheckBox;
	private var loadFileButton:Button;
	
	public function init():Void {
		super.init();
	}
	public function createChildren():Void {
		var serial = new SerialNumber();
		createClassObject(Label, "wLabel", serial.getNumber(), {
			text: "W:",
			fontSize: 14,
			_x: 10,
			_y: 20
		});
		createClassObject(Label, "hLabel", serial.getNumber(), {
			text: "H:",
			fontSize: 14,
			_x: 10,
			_y: 50
		});
		
		var numStepperScaleX = 70;
		var numStepperFontSize = 14;
		createClassObject(NumericStepper, "wProp", serial.getNumber(), {
			minimum: 0,
			maximum: 1000,
			_x: 40,
			_y: 20,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		createClassObject(NumericStepper, "hProp", serial.getNumber(), {
			minimum: 0,
			maximum: 1000,
			_x: 40,
			_y: 50,
			scaleX: numStepperScaleX,
			fontSize: numStepperFontSize
		});
		
		attachMovie("ColorPicker", "canvasColorPicker", serial.getNumber()).init(40, 80);
		
		this.createClassObject(CheckBox, "snapCheckBox", serial.getNumber(), {
			label: "Grid",
			_x: 40,
			_y: 110,
			fontSize: numStepperFontSize
		});
		
		this.createClassObject(Button, "loadFileButton", serial.getNumber(), {
			label: "Import SVG",
			_x: 10,
			_y: 150,
			fontSize: numStepperFontSize,
			scaleX: 120
		});
		//loadFileButton.setSize(150);
		
		// set Events
		var self = this;
		var numStepperListener = {
			focusIn: function() {
				self.onSetFocus();
			},
			focusOut: function() {
				self.onKillFocus();
			},
			change: function() {
				self.onPropertyChanged();
			}
		};
		wProp.addEventListener("focusIn", numStepperListener);
		wProp.addEventListener("focusOut", numStepperListener);
		wProp.addEventListener("change", numStepperListener);
		hProp.addEventListener("focusIn", numStepperListener);
		hProp.addEventListener("focusOut", numStepperListener);
		hProp.addEventListener("change", numStepperListener);
		canvasColorPicker.onColorChanged = function() { self.onPropertyChanged(); };
		
		snapCheckBox.addEventListener("click", {
			click: function() {
				if (self.snapCheckBox.selected) {
					self.shapeModel.enableSnapping();
				} else {
					self.shapeModel.disableSnapping();
				}
				self.main.onPropertyChanged();
			}
		});
		
		loadFileButton.addEventListener("click", {
			click: function() {
				var newWindow = PopUpManager.createPopUp(_root, Window, true, {
					closeButton: true,
					title: "Import SVG",
					contentPath: "ImportFilePopupContent"
				});
				newWindow.setSize(300, 200);
				newWindow.addEventListener("click", {
					click: function(evt) {
						evt.target.deletePopUp();
					}
				});
				newWindow.addEventListener("complete", {
					complete: function(evt) {
						evt.target.content.addEventListener("onImport", {
							onImport: function(e) {
								var sc = e.target.getShapeCollection();
								for (var i=0; i<sc.getLength(); i++) {
									self.main.getDocument().getShapeCollection().addItem(sc.getItemAt(i));
								}
								self.main.getCanvas().invalidate();
								newWindow.deletePopUp();
							}
						});
					}
				});
			}
		});
		
		invalidate();
	}
	public function draw():Void {
		super.draw();
		var size = shapeModel.getCanvasSize();
		wProp.value = size.width;
		hProp.value = size.height;
		canvasColorPicker.setColor(shapeModel.getCanvasColor());
		snapCheckBox.selected = shapeModel.isSnapping();
	}
	
	function onSetFocus() {
		focused = true;
	}
	function onKillFocus() {
		focused = false;
	}
	public function onPropertyChanged():Void {
		var size = new Size(wProp.value, hProp.value);
		shapeModel.setCanvasSize(size);
		shapeModel.setCanvasColor(canvasColorPicker.getColor());
		main.onPropertyChanged();
	}
}
