extends GdUnitTestSuite


func test_thing_mover_works():
	var under_test:ThingMover = ThingMover.new()
	add_child(under_test)

	# setup
	under_test.start_transform = Transform3D()
	under_test.end_transform = Transform3D().translated(Vector3(0, -100, 0))
	under_test.duration = 0.5
	
	var start_pos = under_test.global_position
	
	# when I start the movement
	under_test.run_once()
	
	# after 0.5 seconds
	await await_millis(520)
	
	# the thing mover has moved to its end positition
	assert_vector(under_test.global_position)\
		.is_equal_approx(start_pos + Vector3(0, -100, 0), Vector3(0.1, 0.1, 0.1))
	

	
	
