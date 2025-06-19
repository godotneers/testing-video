@tool
class_name TestIndicator
extends Node3D

@onready var _label:Label3D = Assure.exists(%Label3D as Label3D)
var _material:StandardMaterial3D

@export var color:Color = Color.GREEN:
	set(value):
		color = value
		_refresh()
		
@export var text:String = "":
	set(value):
		text = value
		_refresh()
		
@export var is_on:bool = false:
	set(value):
		is_on = value
		if is_on:
			_current_color = color
		else:
			_current_color = Color.BLACK	
		_refresh()

var _current_color:Color = color if is_on else Color.BLACK

func _ready():
	var _light:CSGBox3D = Assure.exists(%Light as CSGBox3D)
	_material = Assure.exists(_light.material as StandardMaterial3D)
	
	if not Engine.is_editor_hint():
		turn_off()
		
	_refresh()

func turn_on():
	is_on = true
	
func turn_off():
	is_on = false
	
func _refresh():
	if not is_node_ready():
		return
		
	_material.albedo_color = _current_color
	_material.emission = _current_color
	_label.text = text
	
