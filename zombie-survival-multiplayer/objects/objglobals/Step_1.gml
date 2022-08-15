if (global.ObjPlayer == noone)
{
	if (instance_exists(objPlayer))
	{
		global.ObjPlayer = instance_find(objPlayer, 0);
	}
}

if (global.ObjGun == noone)
{
	if (global.ObjPlayer != noone)
	{
		global.ObjGun = global.ObjPlayer.gun;
	}
}
