if (instance_exists(ownerInstance))
{
	x = ownerInstance.x;
	y = ownerInstance.y;
	image_xscale = ownerInstance.image_xscale;
	image_yscale = ownerInstance.image_yscale;
	image_index = ownerInstance.image_index;
	image_angle = ownerInstance.image_angle;
	image_speed = ownerInstance.image_speed;
	depth = ownerInstance.depth - 1;
	
	if (defaultMaskIndex != -1)
	{
		mask_index = (ownerInstance.mask_index == SPRITE_NO_MASK) ? SPRITE_NO_MASK : defaultMaskIndex;
	}
}