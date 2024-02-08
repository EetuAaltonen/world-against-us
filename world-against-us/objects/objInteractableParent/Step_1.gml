// INHERIT THE PARENT EVENT
event_inherited();

// TODO: Optimize this code
if (!is_undefined(global.HighlightHandlerRef))
{
	var highlightedInteractableLayer = layer_get_id(LAYER_HIGHLIGHT_INTERACTABLE);
	var highlightedTargetLayer = layer_get_id(LAYER_HIGHLIGHT_TARGET);
		
	if (self == global.HighlightHandlerRef.highlightedInteractable) layer_depth(highlightedInteractableLayer, depth);
	if (self == global.HighlightHandlerRef.highlightedTarget) layer_depth(highlightedTargetLayer, depth);
		
	if ((self != global.HighlightHandlerRef.highlightedInteractable && depth == layer_get_depth(highlightedInteractableLayer)) ||
		(self != global.HighlightHandlerRef.highlightedTarget && depth == layer_get_depth(highlightedTargetLayer))
	)
	{
		depth += 1;
	}
}

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