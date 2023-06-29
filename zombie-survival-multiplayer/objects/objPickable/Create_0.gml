// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Pickup";
interactionFunction = function()
{
	show_message(string(data));
}

mask_index = SPRITE_NO_MASK;

enum PICKABLE_TYPE
{
	Item,
	Unlock
}
image_speed = 0;
type = undefined;
data = undefined;
initPickable = true;