if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	if (!is_undefined(packetHeader.clientId))
	{
		if (owner.character.uuid == packetHeader.clientId)
		{
			switch (packetHeader.messageType)
			{
				case MESSAGE_TYPE.DATA_PLAYER_WEAPON_FUNCTION:
				{
					if (!is_undefined(primaryWeapon))
					{
						var isWeaponUsed = buffer_read(networkBuffer, buffer_u8);
						var newBulletCount = buffer_read(networkBuffer, buffer_u8);
						var isWeaponAiming = buffer_read(networkBuffer, buffer_u8);
						var mouseX = buffer_read(networkBuffer, buffer_u32);
						var mouseY = buffer_read(networkBuffer, buffer_u32);
						var scaledMousePos = ScaleIntValuesToFloatVector2(mouseX, mouseY);
						
						// CALCULATE IMAGE ANGLE AND BARREL LOCATION
						weapon_aim_pos = new Vector2(scaledMousePos.X, scaledMousePos.Y);
						image_angle = point_direction(x, y, weapon_aim_pos.X, weapon_aim_pos.Y);
						CalculateBarrelPos();
						
						if (isWeaponUsed)
						{
							UseWeapon(weapon_aim_pos.X, weapon_aim_pos.Y);
						} else if (isWeaponAiming != isAiming)
						{
							isAiming = isWeaponAiming;	
						} else {
							ReloadWeapon(newBulletCount);
						}
					}
				} break;
				case MESSAGE_TYPE.DATA_PLAYER_WEAPON_EQUIP:
				{
					var jsonString = buffer_read(networkBuffer, buffer_string);
					primaryWeapon = ParseJSONStructToItem(jsonString);
					if (!is_undefined(primaryWeapon))
					{
						initWeapon = true;
					}
				}
			}
		}
	}
}
