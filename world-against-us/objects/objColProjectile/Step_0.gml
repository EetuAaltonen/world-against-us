// INHERIT THE PARENT EVENT
event_inherited();

// CHECK RANGE
if (distance_to_point(damageSource.spawn_point.X, damageSource.spawn_point.Y) > damageSource.range) instance_destroy();

// CHECK IF HIT
if (isTargetHit)
{
	// COLLIDE
	if (instance_exists(collisionTarget))
	{
		if (!is_undefined(collisionTarget.collider.collision_body))
		{
			collisionTarget.collider.collision_body.TakeDamage(damageSource.bullet.metadata.base_damage);
		}
	}
	
	// DESTROY AFTER COLLISION
	instance_destroy();
}
	
if (!is_undefined(damageSource))
{
	// COLLISION CHECK
	if (collisionTarget == noone) {
		var objectCount = array_length(collisionObjects);
		var closestDistance = infinity;
		for (var i = 0; i < objectCount; i++)
		{
			var objectToCheck = collisionObjects[@ i];
			var instanceCount = instance_number(objectToCheck);
			for (var j = 0; j < instanceCount; j++)
			{
				var targetInstanceRef = instance_find(objectToCheck, j);
				if (damageSource.parent_instance_ref.id != targetInstanceRef.id)
				{
					if (CheckProjectileToObjectCollision(self, targetInstanceRef))
					{
						if (!is_undefined(targetInstanceRef.collider.collision_body))
						{
							// CHECK FOR INVINCIBILITY
							if (!targetInstanceRef.collider.collision_body.iframe_timer.IsTimerTriggered())
							{
								continue;
							}
						}
						
						// CHECK 
						var distanceToTarget = point_distance(
							x, y + collider.collision_yoffset,
							targetInstanceRef.x,
							targetInstanceRef.y + targetInstanceRef.collider.collision_yoffset
						);
						if (distanceToTarget < closestDistance)
						{
							collisionTarget = targetInstanceRef;
							closestDistance = distanceToTarget;
						}
					}
				}
			}
		}
	}
	
	if (collisionTarget != noone)
	{
		// STOP SPEED
		speed = 0;
		// TODO: Calculate collision point on hitbox in a script
		// collisionHitboxPos = new Vector(0, 1) Hitbox axies position (x, y) between 0 - 1
		// Top left corner (0, 0) and bottom right (1, 1)
			
		// CALCULATE COLLISION ON THE NEXT FRAME
		// THIS WAY BULLET APPEARS TO REACH IT'S TARGET CORRECTLY AND NOT A FRAME AHEAD
		isTargetHit = true;
	}
}