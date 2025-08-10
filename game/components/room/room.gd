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
@onready var _ground: CSGBox3D = Assure.exists(%Ground as CSGBox3D)
@onready var _wall_north: CSGBox3D = Assure.exists(%WallNorth as CSGBox3D)
@onready var _wall_south: CSGBox3D = Assure.exists(%WallSouth as CSGBox3D)
@onready var _wall_east: CSGBox3D = Assure.exists(%WallEast as CSGBox3D)
@onready var _wall_west: CSGBox3D = Assure.exists(%WallWest as CSGBox3D)


func _ready() -> void:
	_update_room()


func _update_room() -> void:
	if not is_node_ready():
		return

	var half_wall_thickness: float = WALL_THICKNESS / 2.0
	var half_room_x: float = room_size.x / 2.0
	var half_room_y: float = room_size.y / 2.0

	# The top of the ground box should be at y = 0, so its center is at -half_wall_thickness
	var ground_y: float = -half_wall_thickness
	var wall_y: float = HEIGHT / 2.0 - WALL_THICKNESS
	var north_z: float = half_room_y + half_wall_thickness
	var south_z: float = -half_room_y - half_wall_thickness
	var east_x: float = half_room_x + half_wall_thickness
	var west_x: float = -half_room_x - half_wall_thickness
	var wall_x_size: float = room_size.x + 2.0 * WALL_THICKNESS

	# Ground
	_ground.size = Vector3(room_size.x, WALL_THICKNESS, room_size.y)
	_ground.transform.origin = Vector3(0, ground_y, 0)

	# North wall (positive z)
	_wall_north.size = Vector3(wall_x_size, HEIGHT, WALL_THICKNESS)
	_wall_north.transform.origin = Vector3(0, wall_y, north_z)

	# South wall (negative z)
	_wall_south.size = Vector3(wall_x_size, HEIGHT, WALL_THICKNESS)
	_wall_south.transform.origin = Vector3(0, wall_y, south_z)

	# East wall (positive x)
	_wall_east.size = Vector3(WALL_THICKNESS, HEIGHT, room_size.y)
	_wall_east.transform.origin = Vector3(east_x, wall_y, 0)

	# West wall (negative x)
	_wall_west.size = Vector3(WALL_THICKNESS, HEIGHT, room_size.y)
	_wall_west.transform.origin = Vector3(west_x, wall_y, 0)
