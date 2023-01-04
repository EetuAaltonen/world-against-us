// Inherit the parent event
event_inherited();

if (global.GUIStateHandler.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (instance_exists(global.ObjPlayer))
		{
			insideInteractionRange = (point_distance(x, y, global.ObjPlayer.x, global.ObjPlayer.y) < interactionRange);
			if (insideInteractionRange && keyboard_check_released(ord("F")))
			{
				interactionFunction();
			}
		}
	}
}