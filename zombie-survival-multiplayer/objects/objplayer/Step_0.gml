// INHERITED EVENT
event_inherited();

if (character.type == CHARACTER_TYPE.PLAYER)
{
	// CHECK GUI STATE
	if (!global.GUIStateHandler.IsGUIStateClosed()) return;
	GetLocalPlayerMovementInput();
	
	// QUICK HEAL
	if (keyboard_check_released(ord("Q")))
	{
		var medicine = FetchMedicineFromPockets();
		if (!is_undefined(medicine))
		{
			character.UseMedicine(medicine)
		} else {
			// MESSAGE LOG
			AddMessageLog(string("Quick healing failed, missing healing items"));
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

hSpeed = clamp(hSpeed, -maxSpeed, maxSpeed);
vSpeed = clamp(vSpeed, -maxSpeed, maxSpeed);
dirSpeed = sqrt((hSpeed * hSpeed) + (vSpeed * vSpeed));

if (place_meeting(x + hSpeed, y, objBlockParent))
{
	while (!place_meeting(x + sign(hSpeed), y, objBlockParent))
	{
		x += sign(hSpeed);
	}
	hSpeed = 0;
}
x += hSpeed;
var sprWidthCenter = sprite_get_width(sprite_index) * 0.5;
x = clamp(x, 0 + sprWidthCenter, room_width - sprWidthCenter);

if (place_meeting(x, y + vSpeed, objBlockParent))
{
	while (!place_meeting(x, y + sign(vSpeed), objBlockParent))
	{
		y += sign(vSpeed);
	}
	vSpeed = 0;
}
y += vSpeed;
var sprHeightCenter = sprite_get_height(sprite_index) * 0.5;
y = clamp(y, 0 + sprHeightCenter, room_height - sprHeightCenter);

// SEND MOVEMENT NETWORK DATA
if (character.type == CHARACTER_TYPE.PLAYER)
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
}