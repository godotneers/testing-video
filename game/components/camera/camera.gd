class_name Camera
extends Node3D

@export var min_distance:float = 4
@export var max_distance:float = 100

@onready var _camera:Camera3D = Assure.exists(%Camera3D as Camera3D)
@onready var _arm:SpringArm3D = Assure.exists(%Arm as SpringArm3D)

func _ready() -> void:
	_camera.position.z = min_distance
	
func _input(evt:InputEvent):
	if evt is InputEventMouseMotion:
		_move_camera(-evt.relative * get_process_delta_time() * 0.5)
	elif evt.is_action("zoom_in"):
		_zoom_camera(1)
	elif evt.is_action("zoom_out"):
		_zoom_camera(-1)

func _move_camera(movement:Vector2) -> void:
	rotation.y += movement.x
	_arm.rotation.x = clamp(_arm.rotation.x + movement.y, -PI/2, 0.0 )

func _zoom_camera(direction:float) -> void:
	_arm.spring_length = clamp(_arm.spring_length + direction, min_distance, max_distance)
