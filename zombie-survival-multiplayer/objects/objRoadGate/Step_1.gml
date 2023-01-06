// Inherit the parent event
event_inherited();

if (!facility.is_open)
{
	facility.is_open = (electricalNetwork.electricPower > 0);
}
mask_index = facility.is_open ? sprNoMask : sprite_index;
image_index = facility.is_open ? 1 : 0;