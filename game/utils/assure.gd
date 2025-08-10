class_name Assure
extends RefCounted

## Ensures that the given object exists (is not null) and returns the object.
## @param object: The object to check
static func exists(object: Object) -> Object:
	if not is_instance_valid(object):
		var error_message: String = "Object does not exist or is null"
		assert(false, error_message)
	return object
