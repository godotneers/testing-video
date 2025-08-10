class_name Player
extends Node3D

## Player component that combines a player controller and a player pawn.
## This component will set up a player at the position where it's placed,
## then reparent the player pawn to its own parent and destroy itself.

# Properties from Pawn
## Maximum speed in m/s
@export var max_speed:float = 10
## Turn speed per second.
@export_range(1, 720, 1.0, "or_greater", "radians_as_degrees") var turn_speed:float = TAU

# Node references
@onready var _player_pawn: PlayerPawn = Assure.exists(%PlayerPawn as PlayerPawn)

func _ready() -> void:
	# Apply settings to the player pawn
	_player_pawn.max_speed = max_speed
	_player_pawn.turn_speed = turn_speed
	
	# We need to wait 1 frame until our own parent is fully set up
	# before we move the pawn and destroy ourselves.
	_initialize.call_deferred()

func _initialize() -> void:
	# Reparent the player pawn to the parent of this component
	_player_pawn.reparent(get_parent(), true)

	# Queue this node for deletion
	queue_free()
