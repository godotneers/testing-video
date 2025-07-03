extends Node

## Array of levels that can be loaded
@export var levels: Array[PackedScene] = []

## Reference to the CurrentLevel node
@onready var _current_level: Node = Assure.exists(%CurrentLevel as Node)

## Initializes the game shell
func _ready() -> void:
	if levels.size() > 0 and is_instance_valid(levels[0]):
		var level_instance: Node = levels[0].instantiate()
		_current_level.add_child(level_instance)
	else:
		push_error("No levels available to load")
