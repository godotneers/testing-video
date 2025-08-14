class_name Pawn
extends CharacterBody3D


## Maximum speed in m/s
@export var max_speed:float = 10

## Turn speed per second.
@export_range(1, 720, 1.0, "or_greater", "radians_as_degrees") var turn_speed:float = TAU


var forward:Vector3:
	get: return -transform.basis.z
var right:Vector3:
	get: return transform.basis.x

var _desired_velocity:Vector3
var _desired_look_at_location:Vector3 = Vector3.INF


func prefer_to_look_at(location:Vector3):
	_desired_look_at_location = location

func set_desired_direction(direction:Vector3):
	set_desired_velocity(direction * max_speed)

func set_desired_velocity(desired_velocity:Vector3):	
	# do not exceed pawns maximum speed
	var speed = min(desired_velocity.length(), max_speed)
	_desired_velocity = desired_velocity.normalized() * Vector3(1, 0, 1) * speed

func _physics_process(delta: float) -> void:
	velocity = _desired_velocity

	var turn_direction:Vector3 = Vector3.ZERO
	# look at the desired target if set
	if _desired_look_at_location.is_finite():
		turn_direction = global_position.direction_to(_desired_look_at_location).normalized() * Vector3(1,0,1)
	# otherwise turn into walk direction
	elif not _desired_velocity.is_zero_approx():
		# pawn axis always stays perpendicular during turning, so any y component
		# in the direction is ignored.
		turn_direction = _desired_velocity.normalized() * Vector3(1,0,1)
	
	if not turn_direction.is_zero_approx():
		var angle:float = forward.angle_to(turn_direction)
		
		if not is_zero_approx(angle):
			transform = transform.interpolate_with(
				transform.looking_at(global_position + turn_direction),
				clamp(0, 1.0, turn_speed * delta / angle)
			)


	if is_on_floor():
		velocity.y = 0
	else:
		velocity += get_gravity()	
	
	move_and_slide()


func teleport_to(location:Vector3):
	global_position = location
	
