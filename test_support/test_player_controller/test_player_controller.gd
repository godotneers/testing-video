class_name TestPlayerController
extends Node3D


@onready var _navigation_agent:NavigationAgent3D = Assure.exists(%NavigationAgent3D)
var _pawn:PlayerPawn

func _ready() -> void:
	var parent:PlayerPawn = Assure.exists(get_parent() as PlayerPawn)
	_pawn = parent
	
	
func move_to(location:Vector3):
	_navigation_agent.target_position = location
	await _navigation_agent.navigation_finished
	
	
func teleport_to(location:Vector3):
	_pawn.teleport_to(location)
	_navigation_agent.target_position = location
	
func _physics_process(delta: float) -> void:
	if _navigation_agent.is_navigation_finished():
		_pawn.set_desired_velocity(Vector3.ZERO)
		return
		
	var position:Vector3 = _navigation_agent.get_next_path_position()
	_pawn.set_desired_velocity(global_position.direction_to(position) * _pawn.max_speed)
