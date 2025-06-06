class_name PlayerPawn
extends Pawn

## The animation player of this player
@onready var _animation_player:AnimationPlayer = %AnimationPlayer

func attack():
	_animation_player.play("player_animations/Swing")
