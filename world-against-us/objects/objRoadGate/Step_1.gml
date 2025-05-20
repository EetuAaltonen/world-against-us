// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index)
{
	instanceState = event_object;
} else {
	facility.metadata.is_open = (electricalNetwork.electricPower > 0);
	mask_index = facility.metadata.is_open ? SPRITE_NO_MASK : sprite_index;
	image_index = facility.metadata.is_open ? 1 : 0;
}