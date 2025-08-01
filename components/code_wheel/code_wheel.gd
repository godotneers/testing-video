@tool
## The CodeWheel component allows the player to input a 3-digit code using three wheels.
## Each digit can only be in the range 0-3. When the correct code is entered, the code_found signal is emitted.
class_name CodeWheel
extends MarginContainer

const DEFAULT_VALUE:String = "000"

var _value:String = DEFAULT_VALUE

## The current value of the code wheel as a string.
## Each digit is always in the range 0-3.
## @param v The value to set. Invalid values default to "000".
## @return The current value as a string.
@export var value:String = DEFAULT_VALUE:
	set(v):
		if not v.is_valid_int():
			_value = DEFAULT_VALUE
		
		_value = _number_to_code(int(v))
		_refresh()
	get: 
		return _value

@onready var _wheel1:SingleWheel = Assure.exists(%Wheel1 as SingleWheel)
@onready var _wheel2:SingleWheel = Assure.exists(%Wheel2 as SingleWheel)
@onready var _wheel3:SingleWheel = Assure.exists(%Wheel3 as SingleWheel)

## Emitted whenever the value changes to a new value.
## @signal value_changed
signal value_changed(new_value: String)

func _ready():
	_refresh()
	
	if Engine.is_editor_hint():
		return
	
	_wheel1.changed.connect(_update_value)
	_wheel2.changed.connect(_update_value)
	_wheel3.changed.connect(_update_value)
	

func _refresh():
	if not is_node_ready():
		return
		
	_wheel1.set_value_no_signal(int(_value.substr(0, 1)))
	_wheel2.set_value_no_signal(int(_value.substr(1, 1)))
	_wheel3.set_value_no_signal(int(_value.substr(2, 1)))

func _update_value():
	var old_value: String = _value
	_value = "%d%d%d" % [_wheel1.value, _wheel2.value, _wheel3.value]
	if _value != old_value:
		value_changed.emit(_value)

## Converts an integer to a 3-digit code string, clamping each digit to the range 0-3.
## Used to ensure that each wheel only displays valid values.
## @param number The integer to convert to a code.
## @return A string of 3 digits, each in the range 0-3.
static func _number_to_code(number: int) -> String:
	var abs_number = abs(number)
	var first_digit = clamp((abs_number / 100) % 10, 0, 3) 
	var second_digit = clamp((abs_number / 10) % 10, 0, 3) 
	var third_digit = clamp(abs_number % 10, 0, 3) 
	
	return "%d%d%d" % [first_digit, second_digit, third_digit]

## Shuffles the wheels to a random code, ensuring it is never the correct code.
func shuffle(code:String) -> void:
	var rng := RandomNumberGenerator.new()
	var shuffled_code: String = code
	while shuffled_code == code:
		var d1: int = rng.randi_range(0, 3)
		var d2: int = rng.randi_range(0, 3)
		var d3: int = rng.randi_range(0, 3)
		shuffled_code = "%d%d%d" % [d1, d2, d3]
	_value = shuffled_code
	_refresh()
