@tool
extends AudioStreamPlayer3D


func shift_pitch():
	pitch_scale = randf_range(0.8, 1.2)
	print(pitch_scale)
