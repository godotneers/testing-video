
## Code guidelines
Always add GDScript type hints everywhere. When referring to nodes, always use scene unique names instead of paths. Always initialize node references in an `@onready` variable rather than littering the code with inline node references. Always use `is_instance_valid` for null checks. GDScripts should always end with an empty line. All `@onready` variables are private and need to start with an underscore. For emitting signals, always use the type-safe variant, e.g. `my_signal.emit()` rather than `emit_signal("my_signal")`.

## Writing tests
The test framework does not stop execution on failed assertions, so make sure the code after an assertion doesn't assume that the assertion was successful.

## Running tests
You can run tests using the `.\run_tests.cmd` file in the project root. This will run GDUnit4 in Godot and print the test results. Only run tests when specifically being asked about it.