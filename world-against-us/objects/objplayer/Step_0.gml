// INHERIT THE PARENT EVENT
event_inherited();

if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
{
	// CHECK GUI STATE
	if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;
	GetLocalPlayerMovementInput();
	
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
			// LOG NOTIFICATION
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
}

var hInput = key_right - key_left;
var vInput = key_down - key_up;
var inputDir = point_direction(0, 0, hInput, vInput);

hSpeed += lengthdir_x(acceleration, inputDir);
if (hInput == 0)
{
	hSpeed = Approach(hSpeed, 0, acceleration * 2);
}
vSpeed += lengthdir_y(acceleration, inputDir);
if (vInput == 0)
{
	vSpeed = Approach(vSpeed, 0, acceleration * 2);
}

if (global.DEBUGMODE) { maxSpeed = 8; acceleration = 0.5; }

hSpeed = clamp(hSpeed, -maxSpeed, maxSpeed);
vSpeed = clamp(vSpeed, -maxSpeed, maxSpeed);
dirSpeed = sqrt((hSpeed * hSpeed) + (vSpeed * vSpeed));

if (place_meeting(x + hSpeed, y, objBlockParent))
{
	var meetInstance = instance_place(x + hSpeed, y, objBlockParent);
	if (meetInstance.mask_index != SPRITE_NO_MASK)
	{
		while (!place_meeting(x + sign(hSpeed), y, objBlockParent))
		{
			x += sign(hSpeed);
		}
		hSpeed = 0;
	}
}
x += hSpeed;

if (place_meeting(x, y + vSpeed, objBlockParent))
{
	var meetInstance = instance_place(x, y + vSpeed, objBlockParent);
	if (meetInstance.mask_index != SPRITE_NO_MASK)
	{
		while (!place_meeting(x, y + sign(vSpeed), objBlockParent))
		{
			y += sign(vSpeed);
		}
		vSpeed = 0;
	}
}
y += vSpeed;

var spriteDirection = CalculateSpriteDirectionToAim(new Vector2(x, y), MouseWorldPosition());
image_xscale = spriteDirection.image_x_scale;

// SEND MOVEMENT NETWORK DATA
if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.SESSION_IN_PROGRESS)
{
	if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
	{
		if (syncTimer.IsTimerStopped())
		{
			var scaledPosition = ScaleFloatValuesToIntVector2(x, y);
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.DATA_PLAYER_POSITION, global.NetworkHandlerRef.client_id);
			var networkPacket = new NetworkPacket(networkPacketHeader, scaledPosition);
			
			global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
			syncTimer.StartTimer();
		} else {
			syncTimer.Update();	
		}
	}
}
// TODO: Disable networking for now
/*if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
{
	if (!is_undefined(global.ObjNetwork.client.clientId))
	{
		if (global.ObjNetwork.client.tickTimer == 1)
		{
			if (x != prev_x || y != prev_y)
			{				
				var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_POSITION);
				var scaledPosition = ScaleFloatValuesToIntVector2(x, y);
				
				buffer_write(networkBuffer, buffer_u32, scaledPosition.X);
				buffer_write(networkBuffer, buffer_u32, scaledPosition.Y);
				global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				
				// RESET PREVIOUS VALUES
				ResetPlayerPositionValues();
			}
			
			if (hSpeed != prev_hspeed || vSpeed != prev_vspeed)
			{
				var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_VELOCITY);
				var scaledSpeed = ScaleFloatValuesToIntVector2(hSpeed, vSpeed);
				
				buffer_write(networkBuffer, buffer_s16, scaledSpeed.X);
				buffer_write(networkBuffer, buffer_s16, scaledSpeed.Y);
				global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				
				// RESET PREVIOUS VALUES
				ResetPlayerVelocityValues();
			}
		}
		
		if (key_up != prev_key_up || key_down != prev_key_down ||
			key_left != prev_key_left || key_right != prev_key_right)
		{
			var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_MOVEMENT_INPUT);
			
			buffer_write(networkBuffer, buffer_s8, key_up);
			buffer_write(networkBuffer, buffer_s8, key_down);
			buffer_write(networkBuffer, buffer_s8, key_left);
			buffer_write(networkBuffer, buffer_s8, key_right);
			global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
			
			// RESET PREVIOUS VALUES
			ResetPlayerInputValues();
		}
	}
}*/