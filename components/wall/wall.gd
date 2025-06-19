@tool
extends Node3D

@onready var _box: CSGBox3D = %Box

@export var length:float = 5:
	set(value):
		length = value
		_refresh()
		
@export var centered:bool = false:
	set(value):
		centered = value
		_refresh()

func _ready():
	_refresh()

func _refresh():
	if not is_node_ready():
		return
		
	_box.size.x = length
	_box.position.x = 0.0 if centered else length / 2.0	
