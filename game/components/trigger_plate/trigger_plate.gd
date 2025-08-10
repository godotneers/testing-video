extends Node3D

signal pressed()
signal released()
signal state_changed(pressed:bool)

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


var _pressed:bool = false
	

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if _pressed:
		return
		
	_pressed = true
	_animation_player.play("press")
	state_changed.emit(_pressed)
	pressed.emit()
	
func _on_area_3d_body_exited(_body: Node3D) -> void:
	if not _pressed:
		return
		
	_pressed = false
	_animation_player.play("release")
	state_changed.emit(_pressed)
	released.emit()
