function CheckCollisionProjectile(_collisionPoint, _projectile)
{
	var isProjectileCollided = false;
	var nearestInstance = _collisionPoint.nearest_instance;
	
	if (nearestInstance != noone) {
		objectIndexToCheck = nearestInstance.object_index;
		while (isProjectileCollided = false && objectIndexToCheck != -1 && objectIndexToCheck != -100)
		{
			switch (objectIndexToCheck)
			{
				// CHILD OBJECTS
				case objMapEdge:
				{
					objectIndexToCheck = -1;
					break;
				} break;
				
				// PARENT OBJECTS
				case objBlockParent:
				{
				
				
					isProjectileCollided = true;
				} break;
			
				case objBreakableParent:
				{
					if (nearestInstance.damageDelayTimer <= 0)
					{
						nearestInstance.condition = max(0, nearestInstance.condition - _projectile.damageSource.bullet.metadata.base_damage);
						nearestInstance.damageDelayTimer = nearestInstance.damageDelay;
						isProjectileCollided = true;
					}
				} break;
				
				case objCharacterParent:
				{
					if (instance_exists(nearestInstance))
					{
						nearestInstance.character.TakeDamage(_projectile.damageSource);
					}
					
					isProjectileCollided = true;
				} break;
			}
			
			objectIndexToCheck = object_get_parent(objectIndexToCheck);
		}
	}
	
	return isProjectileCollided;
}