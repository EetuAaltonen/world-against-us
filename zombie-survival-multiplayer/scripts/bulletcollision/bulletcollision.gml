function BulletCollisionInteraction(_targetInstance, _bulletInstance)
{
	ds_list_add(_targetInstance.bulletHoles, new BulletHole(new Vector2(_bulletInstance.x, _bulletInstance.y), _bulletInstance.bulletHoleRadius, _bulletInstance.bulletHoleDuration));
	with (_bulletInstance)
	{
		instance_destroy();
	}
}