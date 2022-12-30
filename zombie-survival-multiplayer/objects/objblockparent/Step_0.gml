// UPDATE DEPTH ON VIEW PORT
UpdateInstanceDepthOnViewPort();

var damageSource = instance_place(x, y, objDamageParent);
if (damageSource != noone)
{
	// LOOP THROUGH INTERACTIONS
	var currentObject = object_index;
	var checkInteraction = true;
	while (checkInteraction)
	{
		switch (currentObject)
		{
			case objBlockParent:
			{
				checkInteraction = false;
				
				if (damageSource.object_index == objProjectile)
				{
					BulletCollisionInteraction(self, damageSource);
				}
			} break;
			case objBreakableParent:
			{
				checkInteraction = false;
				
				if (condition > 0)
				{
					if (damageDelayTimer <= 0)
					{
						BreakableCollisionInteraction(self, damageSource);
						damageDelayTimer = damageDelay;
					}
				}
			} break;
			default:
			{
				currentObject = object_get_parent(currentObject);
				if (currentObject == -100 || currentObject == -1) { checkInteraction = false; }
			}
		}
	}
}
