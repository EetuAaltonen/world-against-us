function BreakableCollisionInteraction(_breakableInstance, _damageSource)
{
	switch (_damageSource.object_index)
	{
		case objProjectile:
		{
			_breakableInstance.condition = max(0, _breakableInstance.condition - _damageSource.damage);
			BulletCollisionInteraction(_breakableInstance, _damageSource);
		} break;
		case objExplosiveBlast:
		{
			_breakableInstance.condition = max(0, _breakableInstance.condition - _damageSource.damage);
		} break;
	}
}