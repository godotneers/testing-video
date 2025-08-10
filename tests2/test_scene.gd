extends GdUnitTestSuite

var runner:GdUnitSceneRunner
var player:Node2D

func before_test():
	# Load the level that we want to test and add it to the scene. 
	runner = scene_runner("res://game/levels/level0.tscn")
	
	# Get the player node so we can check its position. 
	player = runner.find_child("Player2D")
	

func test_walk(key:Key, direction:Vector2, test_parameters := [
	[KEY_W, Vector2.UP],
	[KEY_S, Vector2.DOWN],
	[KEY_A, Vector2.LEFT],
	[KEY_D, Vector2.RIGHT]
]) -> void:
	var position = player.global_position
	
	# simulate  keystroke
	runner.simulate_key_press(key)

	# wait 0.5 seconds
	await await_millis(500)

	# release 
	runner.simulate_key_release(key)
	
	# Verify the new position. 
	var new_position = player.global_position
	assert_float(new_position.distance_to(position)).is_greater(100) 
	# Verify the direction.
	assert_vector(position.direction_to(new_position))\
		.is_equal_approx(direction, Vector2(0.01, 0.01))
	
