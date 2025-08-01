extends Node

@export var mapping_context: GUIDEMappingContext
@export var toggle_mouse:GUIDEAction

## Initializes the input manager.
func _ready() -> void:
	if not is_instance_valid(mapping_context):
		push_error("Missing mapping context")
		return

	GUIDE.enable_mapping_context(mapping_context)
	
	toggle_mouse.triggered.connect(_toggle_mouse)


func _toggle_mouse():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:	
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
