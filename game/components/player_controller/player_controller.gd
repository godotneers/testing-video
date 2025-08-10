@tool
extends Node3D
@export var mapping_context:GUIDEMappingContext
@export var player_movement:GUIDEAction
@export var interact: GUIDEAction
@onready var _camera: Camera = Assure.exists(%Camera as Camera)
@onready var _interact_instruction_label: RichTextLabel = Assure.exists(%InteractInstructionLabel as RichTextLabel)
@onready var _code_wheel: CodeWheel = Assure.exists(%CodeWheel as CodeWheel)

var _pawn:PlayerPawn
var _current_interactable: Interactable

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	Assure.exists(player_movement)		
	Assure.exists(mapping_context)
	Assure.exists(interact)

	GUIDE.enable_mapping_context(mapping_context)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	_pawn = Assure.exists(get_parent() as PlayerPawn)

	# Connect to interactable signals to show/hide the interact instruction label
	_pawn.interactable_detected.connect(_on_interactable_detected)
	_pawn.interactable_lost.connect(_on_interactable_lost)
	_interact_instruction_label.visible = false
	_code_wheel.visible = false
	
	# Connect to interact action to show the code wheel when near a pedestal
	interact.triggered.connect(_on_interact_action_triggered)
	_code_wheel.value_changed.connect(_on_code_wheel_value_changed)

func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return
		
	var input_direction: Vector2 = player_movement.value_axis_2d
	var camera_direction: Vector3 = _camera.global_basis * Vector3(input_direction.x, 0, input_direction.y).normalized()
	_pawn.set_desired_direction(camera_direction)
	
	# the camera is top_level so it can rotate freely without being affected by
	# the pawns rotation. We only update its position so it stays with the pawn.
	_camera.global_position = global_position
	

func _get_configuration_warnings() -> PackedStringArray:
	var result:PackedStringArray = []
	if not (get_parent() is PlayerPawn):
		result.append("Player controller must be attached to a player pawn.")
		
	return result

## Called when the player is near an interactable. Shows the interact instruction label.
## If the interactable is a Pedestal, shows and shuffles the Code Wheel.
## @param interactable The interactable that was detected
func _on_interactable_detected(interactable: Interactable) -> void:
	_interact_instruction_label.visible = true
	_current_interactable = interactable

## Called when the player leaves an interactable. Hides the interact instruction label.
## If the interactable is a Pedestal, hides the Code Wheel.
## @param interactable The interactable that was lost
func _on_interactable_lost(interactable: Interactable) -> void:
	_interact_instruction_label.visible = false
	_current_interactable = null
	if interactable is Pedestal:
		_hide_code_wheel()

## Called when the interact action is triggered. Shows the code wheel if near a pedestal.
func _on_interact_action_triggered() -> void:
	if _current_interactable is Pedestal:
		_show_code_wheel()
		_code_wheel.shuffle(_current_interactable.code)
		_interact_instruction_label.visible = false

## Called when the code wheel value changes. Sends the value to the pedestal and hides the code wheel if correct.
## @param new_value The new code entered by the player.
func _on_code_wheel_value_changed(new_value: String) -> void:
	if _current_interactable is Pedestal:
		var pedestal: Pedestal = _current_interactable
		if pedestal.enter_code(new_value):
			_hide_code_wheel()
			_interact_instruction_label.visible = true

## Shows the code wheel and sets the mouse mode to visible.
func _show_code_wheel() -> void:
	_code_wheel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## Hides the code wheel and sets the mouse mode to captured.
func _hide_code_wheel() -> void:
	_code_wheel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
