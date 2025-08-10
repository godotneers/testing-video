class_name Doggo
extends Node3D

## Doggo component that combines a doggo controller and a doggo pawn.
## This component will set up a doggo at the position where it's placed,
## then reparent the doggo pawn to its own parent and destroy itself.

# Properties from Pawn
## Maximum speed in m/s
@export var max_speed:float = 10
## Turn speed per second.
@export_range(1, 720, 1.0, "or_greater", "radians_as_degrees") var turn_speed:float = TAU

# Properties from DoggoController
## Path for the doggo to follow
@export var path: Path3D = null
## Distance at which the doggo considers it has arrived at its destination
@export var arrival_distance: float = 0.5

# Node references
@onready var _doggo_pawn: DoggoPawn = Assure.exists(%DoggoPawn as DoggoPawn)
@onready var _doggo_controller: DoggoController = Assure.exists(%DoggoController as DoggoController)

func _ready() -> void:
	# Apply settings to the doggo pawn
	_doggo_pawn.max_speed = max_speed
	_doggo_pawn.turn_speed = turn_speed
	
	# Apply settings to the doggo controller
	_doggo_controller.path = path
	_doggo_controller.arrival_distance = arrival_distance
	
	# We need to wait 1 frame until our own parent is fully set up
	# before we move the pawn and destroy ourselves.
	_initialize.call_deferred()
	
func _initialize():
	# Reparent the doggo pawn to the parent of this component
	_doggo_pawn.reparent(get_parent(), true)
	
	# Queue this node for deletion
	queue_free()
