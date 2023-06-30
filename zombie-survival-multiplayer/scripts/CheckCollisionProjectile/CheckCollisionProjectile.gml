function CheckCollisionProjectile(_collisionPoint, _projectile)
{
	var isProjectileCollided = false;
	var nearestHitboxInstance = _collisionPoint.nearest_instance;
	
	if (nearestHitboxInstance != noone) {
		var hitboxOwnerInstance = nearestHitboxInstance.ownerInstance;
		if (instance_exists(hitboxOwnerInstance))
		{
			var objectIndexToCheck = hitboxOwnerInstance.object_index;
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
						if (instance_exists(hitboxOwnerInstance))
						{
							if (hitboxOwnerInstance.damageDelayTimer <= 0)
							{
								hitboxOwnerInstance.condition = max(0, hitboxOwnerInstance.condition - _projectile.damageSource.bullet.metadata.base_damage);
								hitboxOwnerInstance.damageDelayTimer = hitboxOwnerInstance.damageDelay;
								isProjectileCollided = true;
							
							}
						}
					} break;
				
					case objCharacterParent:
					{
						if (instance_exists(hitboxOwnerInstance))
						{
							hitboxOwnerInstance.character.TakeDamage(_projectile.damageSource);
						}
					
						isProjectileCollided = true;
					} break;
				}
			
				objectIndexToCheck = object_get_parent(objectIndexToCheck);
			}
		}
	}
	
	return isProjectileCollided;
}