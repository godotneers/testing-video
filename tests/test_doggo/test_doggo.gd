extends TestBase

var _point1:TestArea
var _point2:TestArea
var _point3:TestArea
var _point4:TestArea
var _player_pos:TestArea
var _player_controller:TestPlayerController


func before_test():
	load_scene("uid://coc0qn5voafpo")
	_point1 = find_area("Point1")
	_point2 = find_area("Point2")
	_point3 = find_area("Point3")
	_point4 = find_area("Point4")
	_player_pos = find_area("PlayerPos")
	_player_controller = find_player_controller()

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
	
	# move player so doggo can see it
	await _player_controller.move_to(_player_pos.global_position)
	
	# doggo should move to the player area now
	await assert_signal(_player_pos).wait_until(5000).is_emitted("occupied")	
	
	
	
	
	
