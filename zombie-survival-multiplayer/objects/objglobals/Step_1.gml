if (room != roomLaunch && room != roomMainMenu)
{
	if (global.ObjPlayer == noone)
	{
		if (instance_exists(objPlayer))
		{
			global.ObjPlayer = instance_find(objPlayer, 0);
		}
	}

	if (global.ObjWeapon == noone)
	{
		if (global.ObjPlayer != noone)
		{
			global.ObjWeapon = global.ObjPlayer.weapon;
		}
	}
}

if (keyboard_check_released(ord("B")))
{
	global.DEBUGMODE = !global.DEBUGMODE;
}
