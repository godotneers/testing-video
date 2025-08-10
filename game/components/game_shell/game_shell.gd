extends Node

## Array of levels that can be loaded
@export var levels: Array[PackedScene] = []

## Reference to the CurrentLevel node
@onready var _current_level: Node = Assure.exists(%CurrentLevel as Node)

## Index of the currently loaded level
var _current_level_index: int = 0
## Reference to the currently loaded level instance
var _current_level_instance: Level = null

## Player scene to instantiate at the spawn point
@export var player_scene: PackedScene


## Initializes the game shell
func _ready() -> void:
	Assure.exists(player_scene)
	
	if levels.size() > 0:
		_load_level(_current_level_index)
	else:
		push_error("No levels available to load")


## Loads a level by index, connects to its finish signal
func _load_level(index: int) -> void:
	if is_instance_valid(_current_level_instance):
		_current_level_instance.queue_free()

	var scene: PackedScene = levels[index]
	_current_level_instance = Assure.exists(scene.instantiate() as Level)
	_current_level.add_child(_current_level_instance)
	_current_level_instance.level_finished.connect(_on_level_finished)

	# Find player spawn point in the loaded level
	var spawn_point: Node3D = _current_level_instance.get_tree().get_first_node_in_group("player_spawn_point") as Node3D
	if not is_instance_valid(spawn_point):
		push_error("No player spawn point found in level!")
		return

	var player_instance: Node3D = Assure.exists(player_scene.instantiate() as Node3D)
	player_instance.transform = spawn_point.transform
	_current_level_instance.add_child(player_instance)
	spawn_point.queue_free()


## Handles when a level is finished, loads the next level
func _on_level_finished() -> void:
	_current_level_index = (_current_level_index + 1) % levels.size()
	_load_level(_current_level_index)
