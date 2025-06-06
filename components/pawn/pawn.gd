class_name Pawn
extends CharacterBody3D

## Maximum Health
@export var max_health:int = 100

## Current health
var health:int = max_health

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

var direction:Vector3:
	set(value):
		direction = value.normalized()

var _jump_pending:bool
func jump():
	_jump_pending = true

func _physics_process(delta: float) -> void:
	velocity = direction * max_speed
	if _jump_pending:
		velocity.y -= jump_height / delta
		
	if not direction.is_zero_approx():
		var angle = forward.angle_to(direction)
		if not is_zero_approx(angle):
			transform = transform.interpolate_with(
				transform.looking_at(global_position + direction),
				clamp(0, 1.0, turn_speed * delta / angle)
			)
	
	if not is_on_floor():
		velocity += get_gravity()	
		
	move_and_slide()
	
func take_damage(amount:int):
	health -= amount
	if health < 0:
		queue_free()	
