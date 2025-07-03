@tool
class_name SingleWheel
extends Button

@export var rotation_duration_seconds:float = 0.5

## Emitted when the value was changed
signal changed()

var _value:int = 0
@export_range(0,3) var value:int = 0:
	set(v):
		var new_value = v % 4
		if new_value == _value:
			return
		_value = new_value
		_refresh()
		changed.emit()
	get:
		return _value
		
@onready var _center:Node2D = Assure.exists(%Center as Node2D)
var _tween:Tween

func set_value_no_signal(value:int):
	_value = value % 4
	_refresh()

func _ready():
	pressed.connect(_increase_value)
	_refresh()
	
func _refresh():
	if not is_node_ready():
		return
	# in case some code overrides the value 
	# then this wins over the tween
	if is_instance_valid(_tween):
		_tween.kill() 
		_tween = null
		
	_center.rotation = - TAU / 4.0 * float(value)
		
		
func _increase_value():
	if is_instance_valid(_tween):
		# we're already doing this
		return 
		
	# we deliberately do not do the % 4 here so the tween will not try
	# to flip the wheel backwards. We apply it later when we actually set the new
	# value	
	var new_value = (_value + 1)
	
	_tween = get_tree().create_tween()
	_tween \
		.tween_property(_center, "rotation", - TAU / 4.0 * float(new_value), rotation_duration_seconds) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_IN_OUT) 
		
		
	# setting the new value will invalidate the tween and clamp the value to 0-3	
	_tween.finished.connect(func(): value = new_value)
	
