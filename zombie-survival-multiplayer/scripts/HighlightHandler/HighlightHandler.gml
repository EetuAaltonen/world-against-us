function HighlightHandler() constructor
{
	highlightedInstanceId = undefined;
	
	static Update = function()
	{
		if (global.GUIStateHandlerRef.IsGUIStateClosed())
		{
			if (instance_exists(global.ObjPlayer))
			{
				var newHighlightedId = undefined;
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
									newHighlightedId = instance.id;
									nearestDistance = highlightDistance;
								}
							} else {
								if (instance.id == highlightedInstanceId) { highlightedInstanceId = undefined; }
							}
						}
					}
				}
				if (!is_undefined(newHighlightedId))
				{
					highlightedInstanceId = newHighlightedId;
				}
			}
		} else {
			highlightedInstanceId = undefined;
		}
	}
}