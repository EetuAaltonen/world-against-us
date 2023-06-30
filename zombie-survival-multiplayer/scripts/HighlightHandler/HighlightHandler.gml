function HighlightHandler() constructor
{
	highlightedTarget = noone;
	highlightedInteractable = noone;
	
	static Update = function()
	{
		if (instance_exists(global.ObjPlayer))
		{
			var newHighlightedInstance = noone;
			var nearestDistance = undefined;
			var instanceCount = instance_number(objInteractableParent);
			for (var i = 0; i < instanceCount; i++)
			{
				var instance = instance_find(objInteractableParent, i);
				if (instance_exists(instance))
				{
					if (!is_undefined(instance.interactionFunction))
					{
						var offsetToBottomY = (instance.sprite_height - instance.sprite_yoffset);
						var playerOffsetToBottomY = (global.ObjPlayer.sprite_height - global.ObjPlayer.sprite_yoffset);
						var distanceToPlayer = point_distance(instance.x, instance.y + offsetToBottomY, global.ObjPlayer.x, global.ObjPlayer.y + playerOffsetToBottomY);
						if (distanceToPlayer <= instance.interactionRange)
						{
							var offsetToCenterY = ((instance.sprite_height * 0.5) - instance.sprite_yoffset);
							var distanceToMouse = point_distance(instance.x, instance.y + offsetToCenterY, mouse_x, mouse_y);
							var distanceMouseToPlayer = point_distance(mouse_x, mouse_y, global.ObjPlayer.x, global.ObjPlayer.y + playerOffsetToBottomY);
							var highlightDistance = min(
								distanceToPlayer,
								(distanceMouseToPlayer < instance.interactionRange) ? distanceToMouse : distanceMouseToPlayer
							);
							if (highlightDistance < (nearestDistance ?? (instance.interactionRange + 1)))
							{
								newHighlightedInstance = instance;
								nearestDistance = highlightDistance;
							}
						} else {
							if (instance == highlightedInteractable)
							{
								ResetHighlightedInstance(LAYER_HIGHLIGHT_INTERACTABLE);
								highlightedInteractable = noone;
							}
						}
					}
				}
			}
			if (newHighlightedInstance != noone)
			{
				SetHighlightedInstance(newHighlightedInstance, LAYER_HIGHLIGHT_INTERACTABLE);
				highlightedInteractable = newHighlightedInstance;
			}
		}
	}
	
	static SetHighlightedInstance = function(_newHighlightedInstance, _highlightLayerName)
	{
		if (instance_exists(_newHighlightedInstance))
		{
			var highlightLayerId = layer_get_id(_highlightLayerName);
			layer_depth(highlightLayerId, _newHighlightedInstance.depth);
			layer_add_instance(highlightLayerId, _newHighlightedInstance);
		}
	}
	
	static ResetHighlightedInstance = function(_highlightLayerName)
	{
		if (instance_exists(highlightedInteractable))
		{
			var highlightLayerId = layer_get_id(_highlightLayerName);
			highlightedInteractable.depth = highlightedInteractable.depth - 1;
			layer_depth(highlightLayerId, -1);
		}
	}
}