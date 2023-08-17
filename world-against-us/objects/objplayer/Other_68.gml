if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	if (!is_undefined(packetHeader.clientId))
	{
		if (character.uuid == packetHeader.clientId)
		{
			switch (packetHeader.messageType)
			{
				case MESSAGE_TYPE.DATA_PLAYER_POSITION:
				{
					var xPos = buffer_read(networkBuffer, buffer_u32);
					var yPos = buffer_read(networkBuffer, buffer_u32);
					var scaledPosition = ScaleIntValuesToFloatVector2(xPos, yPos);
					
					x = scaledPosition.X;
					y = scaledPosition.Y;
				} break;
				case MESSAGE_TYPE.DATA_PLAYER_VELOCITY:
				{
					var horizontalSpeed = buffer_read(networkBuffer, buffer_s16);
					var verticalSpeed = buffer_read(networkBuffer, buffer_s16);
					var scaledSpeed = ScaleIntValuesToFloatVector2(horizontalSpeed, verticalSpeed);
					
					hSpeed = scaledSpeed.X;
					vSpeed = scaledSpeed.Y;
				} break;
				case MESSAGE_TYPE.DATA_PLAYER_MOVEMENT_INPUT:
				{
					key_up = buffer_read(networkBuffer, buffer_s8);
					key_down = buffer_read(networkBuffer, buffer_s8);
					key_left = buffer_read(networkBuffer, buffer_s8);
					key_right = buffer_read(networkBuffer, buffer_s8);
				} break;
			}
		}
	}
}
