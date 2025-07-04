## Base component for things that can be picked up.
## This class is intended to be derived from by actual pickups.
class_name Pickup
extends Node3D


## Called when the pickup is dropped.
## @param global_pos: The global position where the pickup should move to.
func drop(global_pos: Vector3) -> void:
	global_position = global_pos
	_drop()

## Called when the pickup is picked up.
## @param global_pos: The global position where the pickup should move to.
func pick_up(global_pos: Vector3) -> void:
	global_position = global_pos
	_pick_up()

## Override this function in derived classes to implement pickup-specific drop behavior.
func _drop() -> void:
	pass

## Override this function in derived classes to implement pickup-specific pick up behavior.
func _pick_up() -> void:
	pass
