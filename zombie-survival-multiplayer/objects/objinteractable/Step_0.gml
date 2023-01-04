// Inherit the parent event
event_inherited();

if (global.GUIStateHandler.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (keyboard_check_released(ord("F")))
		{
			if (instance_exists(global.ObjPlayer))
			{
				if (global.HighlightHandlerRef.highlightedInstanceId == id)
				{
					interactionFunction();
				}
			}
		}
	}
}