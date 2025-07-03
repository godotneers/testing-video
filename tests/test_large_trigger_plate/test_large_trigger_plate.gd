extends TestBase

var _player_controller:TestPlayerController
var _large_trigger_plate:LargeTriggerPlate
var _pressed_indicator:TestIndicator
var _doggo_pickup:TestArea


func before_test():
	load_scene("uid://xjpjo2cbij4j")
	_player_controller = find_player_controller()
	_large_trigger_plate = find_of_type("LargeTriggerPlate", LargeTriggerPlate)
	_pressed_indicator = find_indicator("PressedIndicator")
	_doggo_pickup = find_area("DoggoPickup")

func test_trigger_does_not_react_to_a_single_body():
	assert_bool(_pressed_indicator.is_on).is_false()
	
	# when the player walks into the plate
	await _player_controller.move_to(_large_trigger_plate.global_position)
	
	# then the pressed indicator is still off because the 
	# pressure plate needs two bodes
	assert_bool(_pressed_indicator.is_on).is_false()
	
func test_trigger_reacts_to_two_bodies():
	monitor_signals(_pressed_indicator)
	assert_bool(_pressed_indicator.is_on).is_false()
	
	# let the player fetch the doggo
	await _player_controller.move_to(_doggo_pickup.global_position)
	
	# and then move towards the trigger plate
	await _player_controller.move_to(_large_trigger_plate.global_position)	

	# give the doggo a bit of time to catch on.
	# once the doggo reaches the trigger plate, the indicator
	# should turn on
	await assert_signal(_pressed_indicator).wait_until(5000).is_emitted("turned_on")	
	
	
	
	
	
	
