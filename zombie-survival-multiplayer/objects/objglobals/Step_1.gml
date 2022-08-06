if (global.ObjPlayer == noone)
{
	if (instance_exists(objPlayer))
	{
		global.ObjPlayer = instance_find(objPlayer, 0);
	}
}

if (global.ObjGun == noone)
{
	if (instance_exists(objGun))
	{
		global.ObjGun = instance_find(objGun, 0);
	}
}
