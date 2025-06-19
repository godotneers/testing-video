class_name TestPlayerController
extends Node3D


@onready var _navigation_agent:NavigationAgent3D = Assure.exists(%NavigationAgent3D)
var _pawn:PlayerPawn

func _ready() -> void:
	var parent:Node3D = get_parent()
	Assure.is_true(parent is PlayerPawn)
	_pawn = parent
	
	
func move_to(location:Vector3):
	_navigation_agent.target_position = location
	await _navigation_agent.navigation_finished
	
	
func teleport_to(location:Vector3):
	_pawn.global_position = location	
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
func _physics_process(delta: float) -> void:
	if _navigation_agent.is_navigation_finished():
		_pawn.direction = Vector3.ZERO
		return
		
	var position:Vector3 = _navigation_agent.get_next_path_position()
	_pawn.direction = global_position.direction_to(position)
