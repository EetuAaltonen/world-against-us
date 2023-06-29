// INHERIT THE PARENT EVENT
event_inherited();

// SET IMAGE INDEX
if (initPickable)
{
	if (!is_undefined(data))
	{
		initPickable = false;
		sprite_index = data.icon;
	}
}