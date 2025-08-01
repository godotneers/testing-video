@tool
## Room CSG node that forms a box-shaped room with configurable width and length.
## The height is fixed to 5 meters and wall thickness to 1 meter.
## The room is always positioned so its floor is at y=0 and centered at the origin.
class_name Room
extends Node3D

## The width (x) and length (z) of the room in meters.
@export var room_size: Vector2 = Vector2(40, 40):
	set(value):
		room_size = value
		_update_room()

const HEIGHT: float = 5.0
const WALL_THICKNESS: float = 1.0
@onready var _subtract: CSGBox3D = Assure.exists(%Subtract as CSGBox3D)
@onready var _room: CSGBox3D = Assure.exists(%Room as CSGBox3D)


func _ready() -> void:
	_update_room()


func _update_room() -> void:
	if not is_node_ready():
		return

	# Outer box (walls)
	_room.size = Vector3(room_size.x + 2 * WALL_THICKNESS, \
			HEIGHT + WALL_THICKNESS, \
			room_size.y + 2 * WALL_THICKNESS)
	# Center the room at the origin, floor at y=0
	_room.transform.origin = Vector3(0, HEIGHT/2 - WALL_THICKNESS, 0)

	# Subtract box (removes interior and top)
	_subtract.size = Vector3(
		room_size.x,
		HEIGHT, # Make subtract box taller to remove the top
		room_size.y
	)
	_subtract.transform.origin = Vector3(0, WALL_THICKNESS, 0)
