
## Code guidelines
Always add GDScript type hints everywhere. When referring to nodes, always use scene unique names instead of paths. Always initialize node references in an `@onready` variable rather than littering the code with inline node references. Always use `is_instance_valid` for null checks. GDScripts should always end with an empty line. All `@onready` variables are private and need to start with an underscore. For emitting signals, always use the type-safe variant, e.g. `my_signal.emit()` rather than `emit_signal("my_signal")`.

## Writing tests
The test framework does not stop execution on failed assertions, so make sure the code after an assertion doesn't assume that the assertion was successful.

## Running tests
You can run tests using the `.\run_tests.cmd` file in the project root. This will run GDUnit4 in Godot and print the test results. Only run tests when specifically being asked about it.

To run only a single test suite, you can use the `-a` parameter to specify the test file or method. For example:

```
.\run_tests.cmd -a tests\test_large_trigger_plate\test_large_trigger_plate.gd
```

To run a specific test method, use the format `test_file.gd:test_method_name`:

```
.\run_tests.cmd -a tests\test_large_trigger_plate\test_large_trigger_plate.gd:test_trigger_reacts_to_two_bodies
```