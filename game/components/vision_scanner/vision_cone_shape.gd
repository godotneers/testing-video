@tool
class_name VisionConeShape
extends ConvexPolygonShape3D

## The field of view of the cone.
@export_range(45, 360, 0.5, "radians_as_degrees") var field_of_view = PI/2:
	set(value):
		field_of_view = value
		_update_cone()

## The view distance of the cone.
@export_range(1, 100, 0.1, "or_greater") var view_distance: float = 5:
	set(value):
		view_distance = value
		_update_cone()

## The number of radial segments of the cone.
@export var segments: int = 8:
	set(value):
		segments = value
		_update_cone()


func _init() -> void:
	_update_cone()


# Updates shape size
func _update_cone() -> void:
	var result: PackedVector3Array = []
	
	# Add the apex of the cone at the origin
	result.append(Vector3.ZERO)
	
	# Calculate the radius of the circle at the view distance
	# The radius is calculated using trigonometry: radius = distance * tan(angle/2)
	# see: https://en.wikipedia.org/wiki/Trigonometric_functions
	var radius: float = view_distance * tan(field_of_view / 2.0)
	
	# Calculate points around the circle at the view distance
	for i in range(segments):
		# Calculate the angle for this segment
		var angle: float = TAU * i / segments
		
		# Calculate the point on the circle
		# The circle is on the XY plane (Z is forward in this context)
		var x: float = radius * cos(angle)
		var y: float = radius * sin(angle)
		
		# Add the point to the result 
		# We orient the cone to negative z because that
		# is Godot's convention for "forward" in 3D.
		result.append(Vector3(x, y, -view_distance))
	
	points = result
