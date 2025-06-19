@tool
class_name Bone
extends StaticBody3D

@export var rotation_speed: float = 1.0
@onready var _bone_csg: CSGCombiner3D = %BoneCSG

func _process(delta: float) -> void:
	# Rotate only the bone CSG around the y-axis
	_bone_csg.rotate_y(rotation_speed * delta)
