if (global.MultiplayerMode)
{
	if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
	{
			/*
			if (hSpeed != prev_hspeed || vSpeed != prev_vspeed)
			{
				var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_VELOCITY);
				var scaledSpeed = ScaleFloatValuesToIntVector2(hSpeed, vSpeed);
				
				buffer_write(networkBuffer, buffer_s16, scaledSpeed.X);
				buffer_write(networkBuffer, buffer_s16, scaledSpeed.Y);
				global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				
				// RESET PREVIOUS VALUES
				ResetPlayerVelocityValues();
			}*/
		}
	}
}