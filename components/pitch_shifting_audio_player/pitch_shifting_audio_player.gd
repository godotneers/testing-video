@tool
class_name PitchShiftingAudioPlayer
extends AudioStreamPlayer3D


func shift_and_play(from_position:float = 0.0):
	pitch_scale = randf_range(0.8, 1.2)
	play(from_position)
