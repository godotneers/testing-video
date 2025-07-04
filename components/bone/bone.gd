@tool
class_name Bone
extends Pickup

@export var rotation_speed: float = 1.0
@onready var _bone_csg: CSGCombiner3D = Assure.exists(%BoneCSG as CSGCombiner3D)
@onready var _area: Area3D = Assure.exists(%Area3D as Area3D)
@onready var _picked_up_transform: Marker3D = Assure.exists(%PickedUpTransform as Marker3D)
@onready var _dropped_transform: Marker3D = Assure.exists(%DroppedTransform as Marker3D)

func _process(delta: float) -> void:
	# Rotate only the bone CSG around the y-axis
	_bone_csg.rotate_y(rotation_speed * delta)

func _pick_up() -> void:
	_bone_csg.reparent(_picked_up_transform)
	_area.monitorable = false

func _drop() -> void:
	_bone_csg.reparent(_dropped_transform)
	_area.monitorable = true
