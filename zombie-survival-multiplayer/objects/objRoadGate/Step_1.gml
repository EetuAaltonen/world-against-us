// Inherit the parent event
event_inherited();

facility.metadata.is_open = (electricalNetwork.electricPower > 0);
mask_index = facility.metadata.is_open ? sprNoMask : sprite_index;
image_index = facility.metadata.is_open ? 1 : 0;