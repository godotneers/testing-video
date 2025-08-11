class_name Player2D
extends CharacterBody2D


@export var speed:float = 300

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("left", "right", "forward", "backward")
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
