if (room != roomLaunch && room != roomMainMenu)
{
	if (global.InstancePlayer == noone)
	{
		if (instance_exists(objPlayer))
		{
			global.InstancePlayer = instance_find(objPlayer, 0);
		}
	}

	if (global.InstanceWeapon == noone)
	{
		if (global.InstancePlayer != noone)
		{
			global.InstanceWeapon = global.InstancePlayer.weapon;
		}
	}
}

if (keyboard_check_released(ord("B")))
{
	global.DEBUGMODE = !global.DEBUGMODE;
}
