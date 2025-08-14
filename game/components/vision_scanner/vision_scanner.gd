@tool
class_name VisionScanner
extends Node3D

signal target_acquired
signal target_lost

## The field of view of the cone.
@export_range(45, 360, 0.5, "radians_as_degrees") var field_of_view: float = PI/2:
	set(value):
		field_of_view = value
		_refresh()

## The view distance of the cone.
@export_range(1, 100, 0.1, "or_greater") var view_distance: float = 20.0:
	set(value):
		view_distance = value
		_refresh()

@onready var _ray_cast_3d: RayCast3D = Assure.exists(%RayCast3D)
@onready var _cone_shape: VisionConeShape = Assure.exists(%CollisionShape3D).shape as VisionConeShape

## Whether the scanner currently has a line of sight to the target.
var _has_line_of_sight:bool = false
## The body we're currently tracking.
var _tracked_body:Node3D
## The target object we're aiming at (either a CollisionShape3D or the body itself).
var _target_object:Node3D
## The last known position of the last tracked body.
var _last_known_position:Vector3 = Vector3.INF

## Returns the last known global position of the last target. If we never had a target
## returns Vector3.INF
var last_known_position:Vector3:
	get: return _last_known_position


func _ready() -> void:
	set_physics_process(false)
	_refresh()

## Updates the cone shape with the current field of view and view distance settings.
func _refresh() -> void:
	if not is_node_ready():
		return

	_cone_shape.field_of_view = field_of_view
	_cone_shape.view_distance = view_distance
	

## Adds the given collision object to the ignore list.	
func ignore(object:CollisionObject3D):
	_ray_cast_3d.add_exception(object)


func _physics_process(_delta: float) -> void:
	Assure.exists(_tracked_body)
	Assure.exists(_target_object)
	var had_line_of_sight:bool = _has_line_of_sight

	# Orient the ray cast to the target position
	_ray_cast_3d.target_position = _ray_cast_3d.to_local(_target_object.global_position)
	_ray_cast_3d.force_raycast_update()

	# Check if we have line of sight
	_has_line_of_sight = _ray_cast_3d.is_colliding() and _ray_cast_3d.get_collider() == _tracked_body

	if _has_line_of_sight:
		_last_known_position = _tracked_body.global_position

	if not had_line_of_sight and _has_line_of_sight:
		# we just acquired a visual
		target_acquired.emit()
		return

	if had_line_of_sight and not _has_line_of_sight:
		# we just lost the visual
		target_lost.emit()


func _on_vision_cone_body_entered(body: Node3D) -> void:
	if _tracked_body != null:
		# keep tracking what we track right now
		return

	# Initialize the target object (either the first collision shape or the body itself)
	if body is CollisionObject3D:
		# Check if the body has any collision shapes
		for child in body.get_children():
			if child is CollisionShape3D and is_instance_valid(child) and child.shape != null:
				# Use the first collision shape as the target
				_target_object = child
				break

	# If no collision shapes found, well, we're not going to hit this one
	# with a raycast, that's for sure.
	if not is_instance_valid(_target_object):
		return # ignore this

	_tracked_body = body
	# begin tracking the body
	set_physics_process(true)

func _on_vision_cone_body_exited(body:Node3D) -> void:
	if body != _tracked_body:
		# can happen if an object entered that had no collision shape
		return

	_tracked_body = null
	_target_object = null
	# stop processing so we don't waste resources
	set_physics_process(false)
	if _has_line_of_sight:
		_has_line_of_sight = false
		target_lost.emit()
