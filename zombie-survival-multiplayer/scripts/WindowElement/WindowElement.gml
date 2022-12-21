function WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	elementId = _elementId;
	position = _position;
	size = _size;
	backgroundColor = _backgroundColor;
	
	parentWindow = undefined;
	parentElement = undefined;
	
	childElements = ds_list_create();
	
	onCreate = true;
	
	isVisible = true;
	isActive = true;
	isHovered = false;
	hoverAnimation = isHovered;
	
	static AddChildElements = function(_childElements)
	{
		// ASSING THE PARENT ELEMENT TO CHILD ELEMENTS
		var childElementCount = ds_list_size(_childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = _childElements[| i];
			childElement.parentWindow = parentWindow;
			childElement.parentElement = self;
		}
		childElements = _childElements;
	}
	
	static InitRelativePosition = function()
	{
		var parent = parentElement ?? parentWindow;
		var newPosition = new Vector2(
			parent.position.X + position.X,
			parent.position.Y + position.Y
		);
		position = newPosition;
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
	
	static Update = function()
	{
		if (isActive)
		{
			if (onCreate)
			{
				onCreate = false;
				InitRelativePosition();
			}
			
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
			childElement.Update();
		}
	}
	
	static UpdateContent = function()
	{
		// OVERRIDE FUNCTION
		return;
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
	
	static OnHoveredEnd = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static Draw = function()
	{
		if (isVisible)
		{
			if (!onCreate)
			{
				DrawBackground();
				DrawContent();
			}
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