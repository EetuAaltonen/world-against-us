// INHERIT THE PARENT EVENT
event_inherited();

if (instance_exists(owner))
{
	depth = owner.depth - 1;
}

// FETCH WEAPON DATA
if (initWeapon)
{
	if (owner != noone && !is_undefined(primaryWeapon))
	{
		initWeapon = false;
		InitializeWeapon();
			
		if (owner.character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
		{
			// TODO: Fix weapon equip network coding
			/*if (!is_undefined(global.ObjNetwork.client.clientId))
			{
				// NETWORKING WEAPON EQUIP FUNCTIONS
				var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_WEAPON_EQUIP);
				var jsonData = json_stringify(primaryWeapon);
			
				buffer_write(networkBuffer, buffer_text, jsonData);
				global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
			}*/
		}
	}
}