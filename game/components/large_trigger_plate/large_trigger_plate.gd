@tool
## A large pressure plate that requires a minimum number of entities to activate.
## 
## This component detects when entities enter or exit its area and activates when
## the number of entities reaches or exceeds the minimum_entity_count.
## 
## Sound effects:
## - When the plate moves up or down, it plays the sliding_sound
## - When entities enter or exit but don't meet the minimum count, it plays the locked_sound
##
## Usage:
## 1. Set the minimum_entity_count to define how many entities are needed to activate
## 2. Assign appropriate AudioStream resources to sliding_sound and locked_sound
## 3. Connect to the pressed, released, or state_changed signals to respond to plate activation
class_name LargeTriggerPlate
extends Node3D


## Emitted when the plate is pressed down (enough bodies entered)
signal pressed()
## Emitted when the plate is released (not enough bodies remain)
signal released()
## Emitted when the plate changes state
signal state_changed(pressed:bool)

## The minimum number of entities required to activate the trigger plate
@export_range(1,10) var minimum_entity_count:int = 2:
	set(value):
		minimum_entity_count = value
		_refresh()

## Sound played when the plate moves up or down
@export var sliding_sound: AudioStream
## Sound played when entities enter/exit but minimum count is not reached
@export var locked_sound: AudioStream

@onready var _area3d:Area3D = %Area3D
@onready var _animation_player:AnimationPlayer = Assure.exists(%LargeTriggerPlate/AnimationPlayer as AnimationPlayer)
@onready var _audio_player:AudioStreamPlayer3D = Assure.exists(%AudioPlayer as AudioStreamPlayer3D)

var _pressed:bool

## How many bodies are inside of the area?
var occupancy:int:
	get: return _area3d.get_overlapping_bodies().size()


func _ready():
	_refresh()
	_area3d.body_entered.connect(_on_body_count_changed.unbind(1))
	_area3d.body_exited.connect(_on_body_count_changed.unbind(1))


func _refresh():
	if not is_node_ready():
		return

## Called when a body enters or exits the trigger area
## Handles state changes and plays appropriate sounds
func _on_body_count_changed():
	var should_be_pressed = occupancy >= minimum_entity_count

	# If there's a state change (pressed/released)
	if should_be_pressed != _pressed:
		if not _pressed:
			pressed.emit()
			_animation_player.play("Down")
		else:
			released.emit()		
			_animation_player.play("Up")

		# Play sliding sound when the plate moves
		if is_instance_valid(sliding_sound):
			_audio_player.stream = sliding_sound
			_audio_player.play()

		state_changed.emit(should_be_pressed)
		_pressed = should_be_pressed
	else:
		# No state change, but a body entered/exited while not meeting minimum requirement
		# Play locked sound to indicate the plate can't move yet, but only if no sound is currently playing
		# This ensures the sliding sound is not interrupted
		if is_instance_valid(locked_sound) and not _audio_player.playing:
			_audio_player.stream = locked_sound
			_audio_player.play()
