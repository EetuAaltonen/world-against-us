// INHERITED EVENT
event_inherited();

if (condition <= 0)
{
	visible = false;
	
	with (blastInstance)
	{
		// DESTROY EXPLOSIVE BLAST AND SELF
		if (sprite_width >= other.blastRadius)
		{
			instance_destroy();
			instance_destroy(other);
		} else {
			// INCREASE SCALE
			var newSpriteScale = ScaleSpriteToFitSize(
				sprite_index,
				sprite_width + other.blastRadiusStep, sprite_height + other.blastRadiusStep
			);
			image_xscale = newSpriteScale;
			image_yscale = newSpriteScale;
		}
	}
}
