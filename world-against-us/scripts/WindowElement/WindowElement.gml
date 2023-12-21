function WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	elementId = _elementId;
	relativePosition = _relativePosition;
	position = relativePosition.Clone();
	size = _size;
	backgroundColor = _backgroundColor;
	
	parentWindow = undefined;
	parentElement = undefined;
	
	childElements = ds_list_create();
	
	isVisible = true;
	isActive = true;
	isHovered = false;
	hoverAnimation = isHovered;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(childElements);
		childElements = undefined;
	}
	
	static AddChildElements = function(_childElements)
	{
		// DELETE OLD CHILD ELEMENTS
		DestroyDSListAndDeleteValues(childElements);
		
		// ASSING THE PARENT ELEMENT TO CHILD ELEMENTS
		var childElementCount = ds_list_size(_childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = _childElements[| i];
			childElement.position.X = position.X + childElement.relativePosition.X;
			childElement.position.Y = position.Y + childElement.relativePosition.Y;
			childElement.parentWindow = parentWindow;
			childElement.parentElement = self;
			childElement.Update();
		}
		childElements = _childElements;
	}
	
	static GetChildElementById = function(_elementId)
	{
		var foundChildElement = undefined;
		var childElementCount = ds_list_size(childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = childElements[| i];
			if (childElement.elementId == _elementId)
			{
				foundChildElement = childElement;
				break;
			}
		}
		
		return foundChildElement;
	}
	
	static OnUpdate = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static Update = function()
	{
		if (isActive)
		{
			OnUpdate();
			UpdateContent();
			if (parentWindow.isFocused)
			{
				CheckHovered();
				CheckInteraction();
			}
			
			hoverAnimation = Approach(hoverAnimation, isHovered, 0.1);
		}
	}
	
	static UpdateChildElements = function()
	{
		var childElementCount = ds_list_size(childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = childElements[| i];
			childElement.position.X = position.X + childElement.relativePosition.X;
			childElement.position.Y = position.Y + childElement.relativePosition.Y;
			childElement.Update();
		}
	}
	
	static UpdateContent = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static DeleteChildElements = function()
	{
		ClearDSListAndDeleteValues(childElements);
	}
	
	static CheckHovered = function()
	{
		if (!is_undefined(size))
		{
			var mousePosition = MouseGUIPosition();
			if (point_in_rectangle(mousePosition.X, mousePosition.Y, position.X, position.Y, (position.X + size.w), (position.Y + size.h)))
			{
				isHovered = true;
			} else {
				if (isHovered)
				{
					isHovered = false;
					OnHoveredEnd();
				}
			}
		}
	}
	
	static CheckInteraction = function()
	{
		if (isHovered)
		{
			CheckContentInteraction();
		}
	}
	
	static CheckContentInteraction = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static OnFocusLostParentWindow = function()
	{
		Update();
	}
	
	static OnHoveredEnd = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static Draw = function()
	{
		if (isVisible)
		{
			DrawBackground();
			DrawContent();
		}
	}
	
	static DrawBackground = function()
	{
		if (!is_undefined(backgroundColor))
		{
			draw_sprite_ext(sprGUIBg, 0, position.X, position.Y, size.w, size.h, 0, backgroundColor, 1);
		}
	}
	
	static DrawContent = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
}