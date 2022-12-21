if (owner != noone)
{
	// POSITION
	x = owner.x;
	y = owner.y + weaponYOffset;
	depth = owner.depth - 1;
	
	if (!is_undefined(primaryWeapon))
	{
		// FETCH WEAPON DATA
		if (initWeapon)
		{
			initWeapon = false;
			InitializeWeapon();
			
			if (owner.character.type == CHARACTER_TYPE.PLAYER)
			{
				if (!is_undefined(global.ObjNetwork.client.clientId))
				{
					// NETWORKING WEAPON EQUIP FUNCTIONS
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_WEAPON_EQUIP);
					var jsonData = json_stringify(primaryWeapon);
			
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
			}
		} else {
			// CALCULATE BARREL LOCATION
			CalculateBarrelPos();
			
			if (owner.character.type == CHARACTER_TYPE.PLAYER)
			{
				// CHECK GUI STATE
				if (global.GUIStateHandler.IsGUIStateClosed())
				{
					image_angle = point_direction(x, y, mouse_x, mouse_y);
					// SHOOTING DELAY AND ANIMATION
					fireDelay = max(-1, fireDelay - 1);
					recoilAnimation = max(0, recoilAnimation - 1);
					
					PlayerWeaponFunctions();
				}
			}
		}
	}

	// ADD RECOIL
	x -= lengthdir_x(recoilAnimation, image_angle);
	y -= lengthdir_y(recoilAnimation, image_angle);
	
	// IMAGE INDEX
	if (!is_undefined(primaryWeapon))
	{
		image_index = is_undefined(primaryWeapon.metadata.magazine);
	}

	// FLIP HORIZONTALLY
	image_yscale = (image_angle > 90 && image_angle < 270) ? -spriteScale : spriteScale;
}
