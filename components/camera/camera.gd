class_name Camera
extends Node3D

@export var camera_movement:GUIDEAction
@export var camera_zoom:GUIDEAction
@export var min_distance:float = 4
@export var max_distance:float = 100

@onready var _camera:Camera3D = %Camera3D
@onready var _arm:SpringArm3D = %Arm

func _ready() -> void:
	_camera.position.z = min_distance
	camera_movement.triggered.connect(_move_camera)
	camera_zoom.triggered.connect(_zoom_camera)

func _move_camera() -> void:
	var movement:Vector2 = camera_movement.value_axis_2d
	rotation.y += movement.x
	_arm.rotation.x = clamp(_arm.rotation.x + movement.y, -PI/2, 0.0 )

func _zoom_camera() -> void:
	_arm.spring_length = clamp(_arm.spring_length + camera_zoom.value_axis_1d, min_distance, max_distance)
