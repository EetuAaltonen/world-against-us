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
					if (damageDelayTimer <= 0)
					{
						nearestInstance.condition = max(0, nearestInstance.condition - _projectile.damageSource.bullet.metadata.base_damage);
						nearestInstance.damageDelayTimer = damageDelay;
						isProjectileCollided = true;
					}
				} break;
				
				case objCharacterParent:
				{
					// TODO: Fix character damage taking, checking the owner object to hit only their enemies
					/*if (damageInstance.object_index == objProjectile)
					{
						character.TakeDamage(damageInstance.damageSource);
						with (damageInstance)
						{
							instance_destroy();	
						}
						checkInteraction = false;
					}*/
					
					isProjectileCollided = true;
				} break;
			}
			
			objectIndexToCheck = object_get_parent(objectIndexToCheck);
		}
	}
	
	return isProjectileCollided;
}