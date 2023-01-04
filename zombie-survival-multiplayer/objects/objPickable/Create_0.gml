// Inherit the parent event
event_inherited();

interactionText = "Pickup";
interactionFunction = function()
{
	show_message(string(data));
}

mask_index = sprNoMask;

enum PICKABLE_TYPE
{
	Item,
	Unlock
}
image_speed = 0;
type = undefined;
data = undefined;
initPickable = true;