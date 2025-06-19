class_name Assure
extends RefCounted

## Static utility class for assuring conditions are met
## This class provides methods to check common conditions and assert when they fail

## Ensures that two objects are equal
## @param actual: The actual object to check
## @param expected: The expected object to compare against
static func are_equal(actual: Variant, expected: Variant) -> void:
	if actual != expected:
		var error_message: String = "Objects are not equal. Expected '%s' but got '%s'" % [expected, actual]
		assert(false, error_message)

## Ensures that the given object does not exist (is null).
## @param object: The object to check
static func does_not_exist(object:Object) -> void:
	if is_instance_valid(object):
		var error_message: String = "Object exists but should be null"
		assert(false, error_message)

## Ensures that the given object exists (is not null) and returns the object.
## @param object: The object to check
static func exists(object: Object) -> Object:
	if not is_instance_valid(object):
		var error_message: String = "Object does not exist or is null"
		assert(false, error_message)
	return object

## Ensures that the given boolean is false
## @param value: The boolean value to check
static func is_false(value: bool) -> void:
	if value:
		var error_message: String = "Value is not false"
		assert(false, error_message)

## Ensures that the given boolean is true
## @param value: The boolean value to check
static func is_true(value: bool) -> void:
	if not value:
		var error_message: String = "Value is not true"
		assert(false, error_message)
