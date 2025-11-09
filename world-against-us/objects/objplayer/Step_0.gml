// INHERIT THE PARENT EVETN
event_inherited();

if (!is_undefined(character))
{
	if (character.behavior == CHARACTER_BEHAVIOR.PLAYER)
	{
		if (!autopilotMode)
		{
			inputDeviceMouse.Update();
			
			// CHECK ACTION INTERRUPTS
			GetCharacterActionInterrupts(self);
			
			// CHECK ACTION INPUT
			GetLocalPlayerInputAction();
			
			// CHECK MOVEMENT INPUT
			inputDeviceMovement.Update();
		} else {
			autopilotInputTimer.Update();
			if (autopilotInputTimer.IsTimerStopped())
			{
				// CALCULATE NEW RANDOM MOVEMENT INPUT
				GenerateAutopilotMovementInput(inputDeviceMovement);
				
				// RESTART AUTOPILOT TIMER
				autopilotInputTimer.StartTimer();
			}
		}
	
		// DEBUG MODE
		maxSpeed = (global.DEBUGMODE) ? 10 : baseMaxSpeed;
		acceleration = (global.DEBUGMODE) ? 0.5 : baseAcceleration;
		if (global.DEBUGMODE)
		{
			if (keyboard_check_released(KEY_DEBUG_PLAYER_AUTOPILOT))
			{
				autopilotMode = !autopilotMode;
				
				if (autopilotMode)
				{
					autopilotInputTimer.StartTimer();
				} else {
					autopilotInputTimer.StopTimer();
				}
				
				var autopilotNotification = string(
					"Player autopilot turned {0}",
					autopilotMode ? "ON" : "OFF"
				);
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						undefined,
						autopilotNotification,
						undefined, NOTIFICATION_TYPE.Log
					)
				);
			}
		}
	}
}

if (character.posture == CHARACTER_POSTURE_HUMAN.STAND)
{
	// CALCULATE INPUT
	var hInput = inputDeviceMovement.key_right - inputDeviceMovement.key_left;
	var vInput = inputDeviceMovement.key_down - inputDeviceMovement.key_up;
	// PREVENTS PLAYER TO MOVE FASTER DIAGONALLY
	var diagonalModifier = ((hInput != 0) && (vInput != 0)) ? 0.707 /*cos(45°)*/ : 1;
	var totalMaxSpeed = maxSpeed * diagonalModifier;

	if (hInput != 0)
	{
		dirSpeed.h_speed = Approach(dirSpeed.h_speed, totalMaxSpeed * sign(hInput), acceleration);
	} else {
		dirSpeed.h_speed = Approach(dirSpeed.h_speed, 0, acceleration * 2);
	}

	if (vInput != 0)
	{
		dirSpeed.v_speed = Approach(dirSpeed.v_speed, totalMaxSpeed * sign(vInput), acceleration);
	} else {
		dirSpeed.v_speed = Approach(dirSpeed.v_speed, 0, acceleration * 2);
	}

	// CHECK COLLISION
	if (place_meeting(x + dirSpeed.h_speed, y, objBlockParent))
	{
		var meetInstance = instance_place(x + dirSpeed.h_speed, y, objBlockParent);
		if (meetInstance.mask_index != SPRITE_NO_MASK)
		{
			var safetyLimit = abs(dirSpeed.h_speed) + 1;
			var safetyCounter = 0;
			while ((!place_meeting(x + sign(dirSpeed.h_speed), y, objBlockParent)) &&
					(safetyCounter < safetyLimit))
			{
				x += sign(dirSpeed.h_speed);
				safetyCounter++;
			}
			dirSpeed.h_speed = 0;
		}
	}
	if (place_meeting(x, y + dirSpeed.v_speed, objBlockParent))
	{
		var meetInstance = instance_place(x, y + dirSpeed.v_speed, objBlockParent);
		if (meetInstance.mask_index != SPRITE_NO_MASK)
		{
			var safetyLimit = abs(dirSpeed.v_speed) + 1;
			var safetyCounter = 0;
			while ((!place_meeting(x, y + sign(dirSpeed.v_speed), objBlockParent)) &&
					(safetyCounter < safetyLimit))
			{
				y += sign(dirSpeed.v_speed);
				safetyCounter++;
			}
			dirSpeed.v_speed = 0;
		}
	}

	// APPLY MOVEMENT
	x += dirSpeed.h_speed;
	y += dirSpeed.v_speed;
}

// CALCULATE IMAGE X-SCALE
if (character.behavior == CHARACTER_BEHAVIOR.PLAYER)
{
	var spriteDirection = CalculateSpriteDirectionToAim(new Vector2(x, y), MouseWorldPosition());
	image_xscale = spriteDirection.image_x_scale;
} else {
	image_xscale = (dirSpeed.h_speed != 0) ? sign(dirSpeed.h_speed) : image_xscale;
}