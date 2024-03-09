function GenerateAutopilotMovementInput(movementInput) {
	// RESET INPUTS
	movementInput.key_up = false;
	movementInput.key_down = false;
	movementInput.key_left = false;
	movementInput.key_right = false;
	
	var roomPaddingX = room_width * 0.2;
	var roomPaddingY = room_height * 0.2;
	
	movementInput.key_up = !(irandom_range(0, 2));
	movementInput.key_down = !(irandom_range(0, 2));
	movementInput.key_left = !(irandom_range(0, 2));
	movementInput.key_right = !(irandom_range(0, 2));
	
	// UP-DOWN
	if (movementInput.key_up && movementInput.key_down)
	{
		var priorUp = irandom_range(0, 1);
		movementInput.key_up = priorUp ? 1 : 0;
		movementInput.key_down = priorUp ? 0 : 1;
	}
	// LEFT-RIGHT
	if (movementInput.key_left && movementInput.key_right)
	{
		var priorLeft = irandom_range(0, 1);
		movementInput.key_left = priorLeft ? 1 : 0;
		movementInput.key_right = priorLeft ? 0 : 1;
	}
	// MAP BOUNDARIES Y
	if (movementInput.key_up && (y < roomPaddingY))
	{
		movementInput.key_up = false;
		movementInput.key_down = true;
	} else if (movementInput.key_down && (y > (room_height - roomPaddingY)))
	{
		movementInput.key_down = false;
		movementInput.key_up = true;
	}
	// MAP BOUNDARIES X
	if (movementInput.key_left && (x < roomPaddingX))
	{
		movementInput.key_left = false;
		movementInput.key_right = true;
	} else if (movementInput.key_right && (x > (room_width - roomPaddingX)))
	{
		movementInput.key_right = false;
		movementInput.key_left = true;
	}
}