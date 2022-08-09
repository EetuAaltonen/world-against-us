var damageSource = instance_place(x, y, objDamageParent);
if (damageSource != noone)
{
	// LOOP THROUGH PARENT INTERACTIONS
	var currentObject = object_index;
	var checkInteraction = true;
	while (checkInteraction)
	{
		switch (currentObject)
		{
			case objBlockParent:
			{
				if (damageSource.object_index == objProjectile)
				{
					BulletCollisionInteraction(self, damageSource);
					checkInteraction = false;
				}
			} break;
			
			case objBreakableParent:
			{
				if (damageDelayTimer <= 0)
				{
					BreakableCollisionInteraction(self, damageSource);
					damageDelayTimer = damageDelay;
					checkInteraction = false;
				}
			} break;
		}
		
		currentObject = object_get_parent(currentObject);
		if (currentObject == -100 || currentObject == -1) { checkInteraction = false; }
	}	
}
