class_name ExitGate
extends Node3D

signal player_entered()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	player_entered.emit()
