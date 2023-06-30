// INHERIT THE PARENT EVENT
event_inherited();

if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (instance_exists(global.HighlightHandlerRef.highlightedInteractable))
		{
			if (global.HighlightHandlerRef.highlightedInteractable.id == id)
			{
				if (keyboard_check_released(ord("F")))
				{
					interactionFunction();
				}
			}
		}
	}
}