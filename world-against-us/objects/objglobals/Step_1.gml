// TODO: Fix this logic
/*if (IS_ROOM_IN_GAME_WORLD)
{
	if (global.InstanceWeapon == noone)
	{
		if (global.InstancePlayer != noone)
		{
			global.InstanceWeapon = global.InstancePlayer.weapon;
		}
	}
}*/

if (keyboard_check_released(ord("B")))
{
	global.DEBUGMODE = !global.DEBUGMODE;
}
