## The Pedestal allows the player to enter a code. Emits a signal when the correct code is entered.
class_name Pedestal
extends Interactable

## Emitted when the correct code is entered.
## @signal
signal code_found()

## The code that must be entered to activate the pedestal.
@export var code: String = ""

## Compares the entered code with the configured code and emits a signal if correct.
## @param entered_code The code entered by the player.
## @return True if the code is correct, false otherwise.
func enter_code(entered_code: String) -> bool:
	if entered_code == code:
		code_found.emit()
		return true
	return false
