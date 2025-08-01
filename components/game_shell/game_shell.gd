extends Node

## Array of levels that can be loaded
@export var levels: Array[PackedScene] = []

## Reference to the CurrentLevel node
@onready var _current_level: Node = Assure.exists(%CurrentLevel as Node)

## Index of the currently loaded level
var _current_level_index: int = 0
## Reference to the currently loaded level instance
var _current_level_instance: Level = null


## Initializes the game shell
func _ready() -> void:
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


## Handles when a level is finished, loads the next level
func _on_level_finished() -> void:
	_current_level_index = (_current_level_index + 1) % levels.size()
	_load_level(_current_level_index)
