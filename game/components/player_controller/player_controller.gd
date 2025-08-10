@tool
extends Node3D
@onready var _camera: Camera = Assure.exists(%Camera as Camera)
@onready var _pawn:PlayerPawn = Assure.exists(get_parent() as PlayerPawn)

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return
		
	var input_direction: Vector2 = \
		Input.get_vector("left", "right", "forward", "backward")
	var camera_direction: Vector3 = _camera.global_basis * Vector3(input_direction.x, 0, input_direction.y).normalized()
	_pawn.set_desired_direction(camera_direction)
	
	# the camera is top_level so it can rotate freely without being affected by
	# the pawns rotation. We only update its position so it stays with the pawn.
	_camera.global_position = global_position
	
