class_name DoggoPawn
extends Pawn

@onready var _animation_tree:AnimationTree = Assure.exists(%AnimationTree as AnimationTree)
@onready var _animation_state_machine:AnimationNodeStateMachinePlayback = \
	Assure.exists(_animation_tree["parameters/playback"])

var attentive:bool = false

func jump():
	_animation_state_machine.travel("jump")


func _physics_process(delta: float) -> void:
	super(delta)
	# match the animation to what the pawn is doing.
	if velocity.is_zero_approx():
		if attentive:
			_animation_state_machine.travel("attentive")
		else:
			_animation_state_machine.travel("idle")
	else:
		_animation_state_machine.travel("walk")
