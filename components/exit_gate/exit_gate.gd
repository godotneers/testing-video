extends Node3D

signal player_entered()

@onready var _area_3d: Area3D = %Area3D


func _on_area_3d_body_entered(_body: Node3D) -> void:
	player_entered.emit()
