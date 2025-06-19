extends GdUnitTestSuite

var _runner:GdUnitSceneRunner
var _controller:TestPlayerController
var _start_point:TestArea
var _end_point:TestArea
var _has_vision_indicator:TestIndicator

func before_test():
	_runner = scene_runner("uid://dw3pfwlyooulr")
	_controller = Assure.exists(_runner.find_child("TestPlayerController") as TestPlayerController)
	_start_point = Assure.exists(_runner.find_child("StartPoint") as TestArea)
	_end_point = Assure.exists(_runner.find_child("EndPoint") as TestArea)
	_has_vision_indicator = Assure.exists(_runner.find_child("HasVisionIndicator") as TestIndicator)

func test_can_detect_player_moving_into_vision():
	# Vision scanner has no visual yet, as player is behind the wall
	assert_bool(_has_vision_indicator.is_on).is_false()
	
	# Move to the spot where the player is visible
	await _controller.move_to(_end_point.global_position)
	
	# Player should be visible now
	assert_bool(_has_vision_indicator.is_on).is_true()

func test_can_detect_player_moving_out_of_sight():
	await _controller.teleport_to(_end_point.global_position)
	
	assert_bool(_has_vision_indicator.is_on).is_true()
	
	# Move to the spot where the player is hidden
	await _controller.move_to(_start_point.global_position)
	
	# Player should be invisible now
	assert_bool(_has_vision_indicator.is_on).is_false()
	
	
