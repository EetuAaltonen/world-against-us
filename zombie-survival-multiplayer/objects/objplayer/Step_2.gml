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
