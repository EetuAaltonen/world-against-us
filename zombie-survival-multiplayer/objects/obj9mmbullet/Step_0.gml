if (isBulletHit)
{
	if (bulletHoleTimer-- <= 0)
	{
		instance_destroy();
	}
}
