extends Marker3D

@onready var attractor:GPUParticlesAttractor3D = %GPUParticlesAttractorSphere3D

@export var max_distance:float = 0.5
@export var speed:float = 8.0
@export var max_strength:float = 6.0

func _process(delta:float) -> void:
	var current_distance:float = attractor.global_position.distance_to(global_position)
	
	if current_distance > max_distance:
		var direction:Vector3 = global_position.direction_to(attractor.global_position)
		attractor.global_position = global_position + direction * max_distance
		
	attractor.global_position = attractor.global_position.move_toward(global_position, speed * delta)
	attractor.strength = max_strength * current_distance / max_distance
		
