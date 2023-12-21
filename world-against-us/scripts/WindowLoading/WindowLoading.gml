function WindowLoading(_elementId, _relativePosition, _size, _backgroundColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	loading_icon = sprLoadingIcon;
	loading_icon_element = undefined;
	loading_icon_rotation_step = 4;
	
	initIconElements = true;
	
	static UpdateContent = function()
	{
		if (initIconElements)
		{
			initIconElements = false;
			// CLEAR CHILD ELEMENTS
			ClearDSListAndDeleteValues(childElements);
			loading_icon_element = undefined;
			
			var loadingIconElements = ds_list_create();
			var loadingIconElementSize = new Size(50, 50);
			var loadingIconElementPosition = new Vector2(
				(size.w * 0.5) - (loadingIconElementSize.w * 0.5),
				(size.h * 0.5) - (loadingIconElementSize.h * 0.5)
			);
			loading_icon_element = new WindowImage(
				"LoadingIconAnimation",
				loadingIconElementPosition,
				loadingIconElementSize, undefined, loading_icon,
				0, 1, 0
			);
			ds_list_add(loadingIconElements, loading_icon_element);
			AddChildElements(loadingIconElements);
		} else {
			if (isVisible)
			{
				if (!is_undefined(loading_icon_element))
				{
					loading_icon_element.rotation -= loading_icon_rotation_step;
					if (loading_icon_element.rotation < -360)
					{
						loading_icon_element.rotation += 360;
					}
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		if (!initIconElements)
		{
			var listElementCount = ds_list_size(childElements);
			for (var i = 0; i < listElementCount; i++)
			{
				var listElement = childElements[| i];
				listElement.Draw();
			}
		}
	}
}