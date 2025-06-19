@tool
extends Node3D

## The pawn this healthbar is attached to
var _pawn: Pawn

## The progress bar that displays the health
@onready var _progress_bar: ProgressBar = %ProgressBar

## The sprite that displays the healthbar in 3D
@onready var _sprite: Sprite3D = %Sprite3D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var parent: Node = get_parent()
	
	if not (parent is Pawn):
		push_error("Pawn healthbar must be attached to a pawn.")
		queue_free()
		return
		
	_pawn = parent
	
	# Connect to the health_changed signal
	_pawn.health_changed.connect(_update_healthbar)
	_update_healthbar(_pawn.health, _pawn.max_health)


## Updates the healthbar based on current health and max health
func _update_healthbar(current_health: int, max_health: int) -> void:
	var health_percent: float = float(current_health) / float(max_health)
	_progress_bar.value = health_percent
	_sprite.visible = health_percent < 1.0

func _get_configuration_warnings() -> PackedStringArray:
	var result:PackedStringArray = []
	if not (get_parent() is Pawn):
		result.append("Pawn healthbar must be attached to a pawn.")
		
	return result
