// Inherit the parent event
event_inherited();

if (condition <= 0)
{
	visible = false;
	// DESTROY EXPLOSIVE BLAST AND SELF
	if (sprite_width >= blastInstance.blastRadius)
	{
		instance_destroy(blastInstance);
		instance_destroy();
	} else {
		// INCREASE SCALE
		var newSpriteScale = ScaleSpriteToFitSize(
			sprite_index,
			new Size(
				sprite_width + blastInstance.blastRadiusStep, 
				sprite_height + blastInstance.blastRadiusStep
			)
		);
		image_xscale = newSpriteScale;
		image_yscale = newSpriteScale;
	}
}
