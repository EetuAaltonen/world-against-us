if (global.ObjPlayer == noone)
{
	if (instance_exists(objPlayer))
	{
		global.ObjPlayer = instance_find(objPlayer, 0);
	}
}
