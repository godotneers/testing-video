class_name Level
extends Node3D

signal level_finished()

func emit_level_finished() -> void:
	level_finished.emit()
