// INHERIT THE PARENT EVENT
event_inherited();

/*if (condition <= 0)
{
	if (blastInstance == noone)
	{
		blastInstance = instance_create_depth(x, y, 0, objExplosiveBlast);
		blastInstance.damage = damage;
	}

	visible = false;
	
	if (blastInstance != noone)
	{
		// DESTROY EXPLOSIVE BLAST AND SELF
		if (blastInstance.sprite_width >= blastRadius)
		{
			instance_destroy(blastInstance);
			instance_destroy();
		} else {
			// INCREASE SCALE
			var newSpriteScale = ScaleSpriteToFitSize(
				blastInstance.sprite_index,
				new Size(
					blastInstance.sprite_width + blastRadiusStep, 
					blastInstance.sprite_height + blastRadiusStep
				)
			);
			blastInstance.image_xscale = newSpriteScale;
			blastInstance.image_yscale = newSpriteScale;
		}
	}
}*/
