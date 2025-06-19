@tool
extends Node3D

@export var player_movement:GUIDEAction
@onready var _camera: Camera = %Camera

var _pawn:PlayerPawn

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var parent:Node = get_parent()

	if not (parent is PlayerPawn):
		push_error("Player controller must be attached to a player pawn.")
		queue_free()
			
	_pawn = parent		
	
		
func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return
		
	var direction = player_movement.value_axis_2d
	var camera_direction = _camera.global_basis * Vector3(direction.x, 0, direction.y).normalized()
	_pawn.set_desired_direction(camera_direction)
	
	# the camera is top_level so it can rotate freely without being affected by
	# the pawns rotation. We only update its position so it stays with the pawn.
	_camera.global_position = global_position
	

func _get_configuration_warnings() -> PackedStringArray:
	var result = []
	if not (get_parent() is PlayerPawn):
		result.append("Player controller must be attached to a player pawn.")
		
	return result
