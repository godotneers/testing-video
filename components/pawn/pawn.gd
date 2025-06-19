class_name Pawn
extends CharacterBody3D


## Maximum speed in m/s
@export var max_speed:float = 10

## Turn speed per second.
@export_range(1, 720, 1.0, "or_greater", "radians_as_degrees") var turn_speed:float = TAU

## Jump height
@export var jump_height:float = 2

var forward:Vector3:
	get: return -transform.basis.z
var right:Vector3:
	get: return transform.basis.x

var _desired_velocity:Vector3

func set_desired_direction(direction:Vector3):
	_desired_velocity = direction.normalized() * max_speed

func set_desired_velocity(desired_velocity:Vector3):	
	# do not exceed pawns maximum speed
	var speed = min(desired_velocity.length(), max_speed)
	_desired_velocity = desired_velocity.normalized() * speed

func _physics_process(delta: float) -> void:
	velocity = _desired_velocity

	# Automagically turn into walk direction
	if not _desired_velocity.is_zero_approx():
		# pawn axis always stays perpendicular during turning, so any y component
		# in the direction is ignored.
		var turn_direction  := _desired_velocity.normalized() * Vector3(1,0,1)
		var angle := forward.angle_to(turn_direction)
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
