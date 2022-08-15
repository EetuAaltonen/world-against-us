function GetLocalPlayerMovementInput() {
	key_up = keyboard_check(ord("W"));
	key_down = keyboard_check(ord("S"));
	key_left = keyboard_check(ord("A"));
	key_right = keyboard_check(ord("D"));
}

function GetRemotePlayerMovementInput(_inputMap) {
	key_up = _inputMap[$ "key_up"] ?? key_up;
	key_down = _inputMap[$ "key_down"] ?? key_down;
	key_left = _inputMap[$ "key_left"] ?? key_left;
	key_right = _inputMap[$ "key_right"] ?? key_right;
}
