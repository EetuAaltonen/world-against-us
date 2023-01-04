// Inherit the parent event
event_inherited();

isOpen = (electricalNetwork.electricPower > 0);
mask_index = isOpen ? sprNoMask : sprite_index;
image_index = isOpen ? 1 : 0;