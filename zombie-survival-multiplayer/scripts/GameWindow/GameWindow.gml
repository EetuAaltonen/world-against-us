function GameWindow(_windowId, _position, _size, _style, _zIndex) constructor
{
	windowId = _windowId;
	
	position = _position;
	size = _size;
	style = _style;
	zIndex = _zIndex;
	
	childElements = ds_list_create();
	
	isActive = true;
	isFocused = false;
	isVisible = true;
	
	static AddChildElements = function(_childElements)
	{
		// ASSING THE PARENT ELEMENT TO CHILD ELEMENTS
		var childElementCount = ds_list_size(_childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = _childElements[| i];
			childElement.position.X = position.X + childElement.relativePosition.X;
			childElement.position.Y = position.Y + childElement.relativePosition.Y;
			childElement.parentWindow = self;
			childElement.parentElement = undefined;
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
	
	static OnOpen = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static Update = function()
	{
		if (isActive)
		{
			UpdateContent();
		}
	}
	
	static UpdateContent = function()
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
	
	static OnFocusLost = function()
	{
		var childElementCount = ds_list_size(childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = childElements[| i];
			childElement.OnFocusLostParentWindow();
		}
	}
	
	static OnClose = function()
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
		if (!is_undefined(style.backgroundColor))
		{
			draw_sprite_ext(sprGUIBg, 0, position.X, position.Y, size.w, size.h, 0, style.backgroundColor, style.backgroundAlpha);
		}
	}
	
	static DrawContent = function()
	{
		var elementCount = ds_list_size(childElements);
		for (var i = 0; i < elementCount; i++)
		{
			var childElement = childElements[| i];
			childElement.Draw();
		}
	}
}