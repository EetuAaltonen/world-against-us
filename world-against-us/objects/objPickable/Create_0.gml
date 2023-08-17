// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Pickup";
interactionFunction = function()
{
	// OVERRIDE THIS FUNCTION
	show_message(string(data));
}

mask_index = SPRITE_NO_MASK;

image_speed = 0;
type = undefined;
data = undefined;
initPickable = true;