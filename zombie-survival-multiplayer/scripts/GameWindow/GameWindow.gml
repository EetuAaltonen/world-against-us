function GameWindow(_windowId, _position, _size, _style, _zIndex) constructor
{
	windowId = _windowId;
	
	position = _position;
	size = _size;
	style = _style;
	zIndex = _zIndex;
	
	childElements = ds_list_create();
	
	onCreate = true;
	
	isActive = true;
	isFocused = false;
	isVisible = true;
	mouseHoverIndex = undefined;
	
	static AddChildElements = function(_childElements)
	{
		// ASSING THE PARENT ELEMENT TO CHILD ELEMENTS
		var childElementCount = ds_list_size(_childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = _childElements[| i];
			childElement.parentWindow = self;
			childElement.parentElement = undefined;
		}
		
		childElements = _childElements;
	}
	
	static Update = function()
	{
		if (isActive)
		{
			if (onCreate)
			{
				onCreate = false;
			}
			
			UpdateContent();
			CheckInteraction();
		}
	}
	
	static UpdateContent = function()
	{
		var childElementCount = ds_list_size(childElements);
		for (var i = 0; i < childElementCount; i++)
		{
			var childElement = childElements[| i];
			childElement.Update();
			if (isFocused)
			{
				childElement.CheckInteraction();
			}
		}
	}
	
	static OnFocusLost = function()
	{
		// OVERRIDE FUNCTION
		return;
	}
	
	static CheckInteraction = function()
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
		draw_sprite_ext(sprGUIBg, 0, position.X, position.Y, size.w, size.h, 0, style.backgroundColor, style.backgroundAlpha);
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