@tool
class_name CodeWheel
extends MarginContainer

const DEFAULT_VALUE:String = "000"

## Emitted when the player found the code
signal code_found()

var _value:String = DEFAULT_VALUE

@export var code:String = DEFAULT_VALUE:
	set(value):
		if not value.is_valid_int():
			code = DEFAULT_VALUE
			return
		
		code = _number_to_code(int(value))

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
	_value = "%d%d%d" % [_wheel1.value, _wheel2.value, _wheel3.value]

static func _number_to_code(number:int) -> String:
	var abs_number = abs(number)
	var first_digit = clamp((abs_number / 100) % 10, 0, 3) 
	var second_digit = clamp((abs_number / 10) % 10, 0, 3) 
	var third_digit = clamp(abs_number % 10, 0, 3) 
	
	return "%d%d%d" % [first_digit, second_digit, third_digit]
			
			
