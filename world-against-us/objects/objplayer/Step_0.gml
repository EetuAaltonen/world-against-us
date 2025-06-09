// INHERIT THE PARENT EVETN
event_inherited();

if (!is_undefined(character))
{
	if (character.behavior == CHARACTER_BEHAVIOR.PLAYER)
	{
		// CHECK GUI STATE
		if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;
		
		if (!autopilotMode)
		{
			GetLocalPlayerMovementInput(movementInput);
		} else {
			autopilotInputTimer.Update();
			if (autopilotInputTimer.IsTimerStopped())
			{
				// CALCULATE NEW RANDOM MOVEMENT INPUT
				GenerateAutopilotMovementInput(movementInput);
				
				// RESTART AUTOPILOT TIMER
				autopilotInputTimer.StartTimer();	
			}
		}
	
		// QUICK HEAL
		if (keyboard_check_released(ord("Q")))
		{
			var medicine = FetchMedicineFromPockets();
			if (!is_undefined(medicine))
			{
				character.UseMedicine(medicine);
				if (medicine.metadata.healing_left <= 0)
				{
					medicine.sourceInventory.RemoveItemByGridIndex(medicine.grid_index);
				}
			} else {
				// NOTIFICATION LOG
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						undefined,
						"Quick healing failed, missing healing items",
						undefined,
						NOTIFICATION_TYPE.Log
					)
				);
			}
		}
		
		// RELOAD WEAPON
		if (keyboard_check_released(ord("R")))
		{
			if (skeletalAnimator.GetActiveAnimationNameByTrack(0) != "rifle_reload")
			{
				skeletalAnimator.SetActiveAnimation("rifle_reload", 0, "upperbody", 1, false, true);
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
		
		// TODO: PROJECTILE TEST
		var mouseWorldPosition = MouseWorldPosition();
		var aimPos = new Vector2(
			mouseWorldPosition.X + abs(equipmentOriginOffset.X),
			mouseWorldPosition.Y + abs(equipmentOriginOffset.Y)
		);
		var spawnPoint = new Vector2(x, bbox_bottom);
		if (keyboard_check_released(vk_space))
		{
			// CREATE PROJECTILE INSTANCE
			var projectileInstance = instance_create_depth(spawnPoint.X, spawnPoint.Y, 0/*top most depth*/, objColProjectile);
			var aimAngle = point_direction(spawnPoint.X, spawnPoint.Y, aimPos.X, aimPos.Y);
			var bulletData = global.ItemDatabase.GetItemByName("9mm Bullet");
			if (!is_undefined(bulletData))
			{
				projectileInstance.sprite_index = asset_get_index(bulletData.metadata.projectile);
				projectileInstance.direction = aimAngle;
				projectileInstance.image_angle = projectileInstance.direction;
				projectileInstance.flySpeed = bulletData.metadata.fly_speed;
				projectileInstance.damageSource = new DamageSource(self, bulletData, MetersToPixels(20), spawnPoint);
				projectileInstance.z = abs(equipmentOriginOffset.Y);
			}
		}
	}
}

// CHECK INPUT
var hInput = movementInput.key_right - movementInput.key_left;
var vInput = movementInput.key_down - movementInput.key_up;
// PREVENTS PLAYER TO MOVE FASTER DIAGONALLY
var diagonalModifier = ((hInput != 0) && (vInput != 0)) ? 0.707 /*cos(radtodeg(45))*/ : 1;
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
		while (!place_meeting(x + sign(dirSpeed.h_speed), y, objBlockParent))
		{
			x += sign(dirSpeed.h_speed);
		}
		dirSpeed.h_speed = 0;
	}
}
if (place_meeting(x, y + dirSpeed.v_speed, objBlockParent))
{
	var meetInstance = instance_place(x, y + dirSpeed.v_speed, objBlockParent);
	if (meetInstance.mask_index != SPRITE_NO_MASK)
	{
		while (!place_meeting(x, y + sign(dirSpeed.v_speed), objBlockParent))
		{
			y += sign(dirSpeed.v_speed);
		}
		dirSpeed.v_speed = 0;
	}
}

// APPLY MOVEMENT
x += dirSpeed.h_speed;
y += dirSpeed.v_speed;

// CALCULATE IMAGE X-SCALE
if (character.behavior == CHARACTER_BEHAVIOR.PLAYER)
{
	var spriteDirection = CalculateSpriteDirectionToAim(new Vector2(x, y), MouseWorldPosition());
	image_xscale = spriteDirection.image_x_scale;
} else {
	image_xscale = (dirSpeed.h_speed != 0) ? sign(dirSpeed.h_speed) : image_xscale;
}