class_name TestBase
extends GdUnitTestSuite

var _runner:GdUnitSceneRunner

func load_scene(path:String):
	_runner = scene_runner(path)

func speed(factor:float):
	_runner.set_time_factor(factor)
	
func find_area(node_name:String) -> TestArea:
	return find_of_type(node_name, TestArea)
	
func find_player_controller(node_name:String = "TestPlayerController") -> TestPlayerController:
	return find_of_type(node_name, TestPlayerController)	

func find_indicator(node_name:String) -> TestIndicator:
	return find_of_type(node_name, TestIndicator)
		
func find_of_type(node_name:String, type:Variant) -> Variant:
	var result = _runner.find_child(node_name)
	Assure.is_true(result != null and is_instance_of(result, type))
	return result
