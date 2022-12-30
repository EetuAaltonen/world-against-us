// UPDATE DEPTH ON VIEW PORT
UpdateInstanceDepthOnViewPort();

if (!is_undefined(character))
{
	if (character.isDead)
	{
		instance_destroy();
	} else {
		character.UpdateStats();
	}
	
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
				case objEnemy:
				{
					if (damageSource.object_index == objProjectile)
					{
						character.TakeDamage(damageSource.damage);
						with (damageSource)
						{
							instance_destroy();	
						}
						checkInteraction = false;
					}
				} break;
				default:
				{
					checkInteraction = false;
				}
			}
		}
	}
}