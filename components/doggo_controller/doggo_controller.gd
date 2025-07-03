@tool
class_name DoggoController
extends Node3D

@export var path: Path3D = null
@export var arrival_distance: float = 0.5
@export var return_time_after_losing_target: float = 3.0

@onready var _vision_scanner: VisionScanner = Assure.exists(%VisionScanner)
@onready var _navigation_agent: NavigationAgent3D = Assure.exists(%NavigationAgent3D)
@onready var _state_chart: StateChart = Assure.exists(%StateChart)

var _path_curve: Curve3D = null
var _current_vertex_index: int = -1
var _pawn: DoggoPawn

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	# prepare pawn
	_pawn = Assure.exists(get_parent() as DoggoPawn)
	
	# prepare navigation
	_navigation_agent.navigation_finished.connect(func(): _state_chart.send_event("target_reached"))
	_navigation_agent.target_desired_distance = arrival_distance
	
	# Connect vision scanner signals
	_vision_scanner.target_acquired.connect(func(): _state_chart.send_event("player_seen"))
	_vision_scanner.target_lost.connect(func(): _state_chart.send_event("player_lost"))
	_vision_scanner.ignore(_pawn)
	
	# If we have a path to follow, set it up
	if is_instance_valid(path) and is_instance_valid(path.curve) and path.curve.point_count > 0:
		_path_curve = path.curve
	_state_chart.set_expression_property("has_path", is_instance_valid(_path_curve))
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not _navigation_agent.is_navigation_finished():
		var next_position: Vector3 = _navigation_agent.get_next_path_position()
		var direction_vector: Vector3 = next_position - global_position
		# Give the agent the desired velocity, taking into account
		# the pawn's maximum speed
		var new_direction = direction_vector.normalized() * _pawn.max_speed
		_navigation_agent.set_velocity(new_direction)
		
		# agent will call us back with the actually allowed velocity
		# see function below

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if Engine.is_editor_hint():
		return
	_pawn.set_desired_velocity(safe_velocity)		
	

func _on_follow_player_state_entered():
	# we begin following the player, so make the pawn attentive
	# and make it jump so we see it is attentive now
	_pawn.attentive = true
	_pawn.jump()
		
		
func _on_follow_player_state_exited():
	# we no longer follow the player, so make the pawn no longer
	# attentive
	_pawn.attentive = false
	_pawn.prefer_to_look_at(Vector3.INF)


func _on_navigate_to_player_state_entered() -> void:
	_navigation_agent.target_position = _vision_scanner.last_known_position
	_pawn.prefer_to_look_at(_vision_scanner.last_known_position)
	_state_chart.send_event("target_acquired")
		
		
func _on_navigate_to_next_point_state_entered() -> void:
	_current_vertex_index = (_current_vertex_index + 1) % _path_curve.point_count
	_navigation_agent.target_position = \
	 	path.global_transform *  _path_curve.get_point_position(_current_vertex_index)
	_state_chart.send_event("target_acquired")


func _get_configuration_warnings() -> PackedStringArray:
	var result: PackedStringArray = []
	if not (get_parent() is DoggoPawn):
		result.append("Doggo controller must be attached to a doggo pawn.")
		
	if not position.is_zero_approx():
		result.append("Doggo controller should not have an offset to the doggo pawn.")
	
	return result


func _on_player_seen_state_entered() -> void:
	_state_chart.send_event("follow_player")

func _on_player_hidden_state_entered() -> void:
	_state_chart.send_event("abandon_player")
