if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (instance_exists(global.ObjPlayer))
		{
			if (global.HighlightHandlerRef.highlightedInstanceId == id)
			{
				var highlightLayer = layer_get_id("HighlightedInstances");
				if (layer != highlightLayer) { layer_add_instance(highlightLayer, self); }
				
				if (keyboard_check_released(ord("F")))
				{
					interactionFunction();
				}
			} else {
				layer_add_instance(defaultLayer, self);
			}
		}
	}
}