extends GdUnitTestSuite

var _runner:GdUnitSceneRunner
var _point1:TestArea
var _point2:TestArea
var _point3:TestArea
var _point4:TestArea
var _player_pos:TestArea
var _player_controller:TestPlayerController


func before_test():
	_runner = scene_runner("uid://coc0qn5voafpo")
	_runner.set_time_factor(5)
	_point1 = Assure.exists(_runner.find_child("Point1") as TestArea)
	_point2 = Assure.exists(_runner.find_child("Point2") as TestArea)
	_point3 = Assure.exists(_runner.find_child("Point3") as TestArea)
	_point4 = Assure.exists(_runner.find_child("Point4") as TestArea)
	_player_pos = Assure.exists(_runner.find_child("PlayerPos") as TestArea)
	_player_controller = Assure.exists(_runner.find_child("TestPlayerController") as TestPlayerController)

func test_doggo_walks_path():
	monitor_signals(_point1)
	monitor_signals(_point2)
	monitor_signals(_point3)
	monitor_signals(_point4)
	await assert_signal(_point1).wait_until(5000).is_emitted("occupied")	
	await assert_signal(_point2).wait_until(5000).is_emitted("occupied")	
	await assert_signal(_point3).wait_until(5000).is_emitted("occupied")	
	await assert_signal(_point4).wait_until(5000).is_emitted("occupied")	
	

func test_doggo_prioritizes_walking_to_player():
	monitor_signals(_point1)
	monitor_signals(_player_pos)
	
	# Wait till doggo reaches first point, from there 
	# it should get a vision of the player.
	await assert_signal(_point1).wait_until(5000).is_emitted("occupied")	
	
	# telport player
	_player_controller.teleport_to(_player_pos.global_position)
	
	# doggo should move to the player area now
	await assert_signal(_player_pos).wait_until(5000).is_emitted("occupied")	
	
	
	
	
	
