function CheckCollisionProjectile(_collisionPoint, _projectile)
{
	var projectileCollisionPosition = _collisionPoint.position;
	var nearestHitboxInstance = _collisionPoint.nearest_instance;
	
	if (nearestHitboxInstance != noone) {
		var hitboxOwnerInstance = nearestHitboxInstance.ownerInstance;
		if (instance_exists(hitboxOwnerInstance))
		{
			var projectileAimAngleLine = new Vector2Line(
				new Vector2(_projectile.x, _projectile.y),
				aimAngleLine.end_point.Clone()
			);
			
			var objectIndexToCheck = hitboxOwnerInstance.object_index;
			while (projectileCollisionPosition != undefined && objectIndexToCheck != -1 && objectIndexToCheck != -100)
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
						// DO NOTHING
					} break;
			
					case objBreakableParent:
					{
						if (instance_exists(hitboxOwnerInstance))
						{
							var collisionPointOnHitbox = CheckCollisionPointOnHitbox(_collisionPoint, projectileAimAngleLine);
							if (hitboxOwnerInstance.damageDelayTimer <= 0)
							{
								//hitboxOwnerInstance.condition = max(0, hitboxOwnerInstance.condition - _projectile.damageSource.bullet.metadata.base_damage);
								hitboxOwnerInstance.damageDelayTimer = hitboxOwnerInstance.damageDelay;
							}
							projectileCollisionPosition = collisionPointOnHitbox;
						}
					} break;
				
					case objCharacterParent:
					{
						if (instance_exists(hitboxOwnerInstance))
						{
							var collisionPointOnHitbox = CheckCollisionPointOnHitbox(_collisionPoint, projectileAimAngleLine);
				
							if (!is_undefined(collisionPointOnHitbox))
							{				
								var targetInstance = _collisionPoint.nearest_instance.ownerInstance;
								var boundingBoxSize = new Size(
									targetInstance.hitboxInstance.bbox_right - targetInstance.hitboxInstance.bbox_left,
									targetInstance.hitboxInstance.bbox_bottom - targetInstance.hitboxInstance.bbox_top
								);
								var collisionBoundingBoxPosition = new Vector2(
									abs(collisionPointOnHitbox.X - targetInstance.hitboxInstance.bbox_left) / boundingBoxSize.w,
									abs(collisionPointOnHitbox.Y - targetInstance.hitboxInstance.bbox_top) / boundingBoxSize.h
								);
								
								var targetBodyPart = targetInstance.character.GetBodyPartByBoundingPosition(collisionBoundingBoxPosition);
								if (!is_undefined(targetBodyPart))
								{
									targetInstance.character.TakeDamage(_projectile.damageSource, targetBodyPart.index);
								}
								projectileCollisionPosition = collisionPointOnHitbox;
							}
						}
					} break;
					default:
					{
						show_debug_message(string("**DEBUG: No detected collision with {0}", object_get_name(objectIndexToCheck)));
					}
				}
				objectIndexToCheck = object_get_parent(objectIndexToCheck);
			}
		}
	}
	
	return projectileCollisionPosition;
}