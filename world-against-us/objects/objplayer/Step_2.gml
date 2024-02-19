if (global.MultiplayerMode)
{
	if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
	{
		positionSyncTImer.Update();
		
		if (movementInput.key_up != prevMovementInput.key_up ||
			movementInput.key_down != prevMovementInput.key_down ||
			movementInput.key_left != prevMovementInput.key_left ||
			movementInput.key_right != prevMovementInput.key_right)
		{
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				movementInput,
				PACKET_PRIORITY.DEFAULT,
				undefined
			);
			if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				// TODO: Generic error handling
				show_debug_message("Unable to queue MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT");
			}
			
			prevMovementInput.key_up = movementInput.key_up;
			prevMovementInput.key_down = movementInput.key_down;
			prevMovementInput.key_left = movementInput.key_left;
			prevMovementInput.key_right = movementInput.key_right;
		
		} else if (positionSyncTImer.IsTimerStopped())
		{
			if (x != previousPosition.X || y != previousPosition.Y )
			{
				var formatPosition = ScaleFloatValuesToIntVector2(x, y);
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PLAYER_DATA_POSITION);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					formatPosition,
					PACKET_PRIORITY.DEFAULT,
					undefined
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					// TODO: Generic error handling
					show_debug_message("Unable to queue MESSAGE_TYPE.PLAYER_DATA_POSITION");
				}
				// UPDATE PREVIOUS POSITION
				previousPosition.X = x;
				previousPosition.Y = y;
				// RESET TIMER
				positionSyncTImer.StartTimer();
			}
		
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