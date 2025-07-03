@tool
class_name LargeTriggerPlate
extends Node3D

signal pressed()
signal released()
signal state_changed(pressed:bool)


@export_range(1,10) var minimum_entity_count:int = 2:
	set(value):
		minimum_entity_count = value
		_refresh()

@onready var _area3d:Area3D = %Area3D
@onready var _animation_player:AnimationPlayer = Assure.exists(%LargeTriggerPlate/AnimationPlayer as AnimationPlayer)
@onready var _audio_player:PitchShiftingAudioPlayer = Assure.exists(%AudioPlayer as PitchShiftingAudioPlayer)

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

func _on_body_count_changed():
	var should_be_pressed = occupancy >= minimum_entity_count
	# no state change
	if should_be_pressed == _pressed:
		return
		
	if not _pressed:
		pressed.emit()
		_animation_player.play("Down")
	else:
		released.emit()		
		_animation_player.play("Up")
		
	_audio_player.shift_and_play()
	
	state_changed.emit(should_be_pressed)
	_pressed = should_be_pressed
