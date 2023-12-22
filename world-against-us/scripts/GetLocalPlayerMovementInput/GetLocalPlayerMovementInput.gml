function GetLocalPlayerMovementInput(movementInput) {
	movementInput.key_up = keyboard_check(ord("W"));
	movementInput.key_down = keyboard_check(ord("S"));
	movementInput.key_left = keyboard_check(ord("A"));
	movementInput.key_right = keyboard_check(ord("D"));
}
