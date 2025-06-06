
## Code guidelines
Always add GDScript type hints everywhere. When referring to nodes. always use scene unique names instead of paths. Always initialize node references in an `@onready` variable rather than littering the code with inline node references. Always use `is_instance_valid` for null checks.

## Creating and editing files
When creating and editing any text file (gdscript, tscn, etc.), make sure to use UTF-8 WITHOUT a byte order mark for the file. GDScripts should always end with an empty line.

## Running tests
You can run tests using the `.\run_tests.cmd` file in the project root. This will run GDUnit4 in Godot and print the test results.