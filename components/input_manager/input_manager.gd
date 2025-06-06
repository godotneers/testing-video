extends Node

@export var mapping_context: GUIDEMappingContext

## Initializes the input manager.
func _ready() -> void:
	if not is_instance_valid(mapping_context):
		push_error("Missing mapping context")
		return

	GUIDE.enable_mapping_context(mapping_context)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
