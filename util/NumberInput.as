import util.*;


class util.NumberInput extends TextInput {
	private var number:Number;
	private var max:Number;
	private var min:Number;
	private var interval:Number;
	private var unit:String;
	private var unitLabel:TextLabel;
	private var incButton:Button;
	private var decButton:Button;
	
	public function init(x, y, max, min, interval, unit):Void {
		super.init(x, y);
		textfield._x = 10;
		this.max = max;
		this.min = min;
		this.interval = interval;
		this.unit = unit;
		if (this.unit && this.unit != "") {
			attachMovie("TextLabel", "unitLabel", 1).init();
			unitLabel.setProperties(unit, 50, 0, 0x000000, 14, "left", "top");
		}
		
		var self = this;
		attachMovie("IncButton", "incButton", 2);
		incButton.onPress = function() {
			self.onIncButtonPress();
		}
		attachMovie("DecButton", "decButton", 3);
		decButton._y = 10;
		decButton.onPress = function() {
			self.onDecButtonPress();
		}
		textfield.onChanged = function() {
			self.inputOnlyNumber();
		}
	}
	public function setNumber(num:Number):Void {
		this.number = num;
		setText(this.number.toString());
	}
	public function getNumber():Number {
		inputOnlyNumber();
		return this.number;
	}
	
	function inputOnlyNumber():Void {
		if (textfield.text == "") {
			number = null;
		} else {
			var i = parseInt(textfield.text);
			if ( ! isNaN(i) ) {
				number = i;
			}
			textfield.text = number.toString();
		}
	}
	function onKeyDown() {
		if (Key.isDown(Key.ENTER)) {
			inputOnlyNumber();
			onEnter();
		}
	}
	function onIncButtonPress() {
		var n = this.getNumber() + interval;
		if (n>max) {
			setNumber(max);
		} else {
			setNumber(n);
		}
		onEnter();
	}
	function onDecButtonPress() {
		var n = this.getNumber() - interval;
		if (n<min) {
			setNumber(min);
		} else {
			setNumber(n);
		}
		onEnter();
	}
}