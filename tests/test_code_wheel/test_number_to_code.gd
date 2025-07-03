extends GdUnitTestSuite

func test_convert(value:int, expected:String, test_parameters := [
	[100, "100"],
	[10, "010"],
	[2123, "123"],
	[500, "300"],
	[-1, "001"]
	]):
	assert_str(CodeWheel._number_to_code(value)).is_equal(expected)
