function GameWindow(_windowId, _type, _guiPos, _size, _zIndex) constructor
{
	windowId = _windowId;
    type = _type;
	
	guiPos = _guiPos;
	size = _size;
	zIndex = _zIndex;
	
	isActive = true;
	isFocused = false;
	isVisible = true;
	mouseHoverIndex = undefined;
	
	static Update = function()
	{
		if (isActive)
		{
			UpdateContent();
			CheckInteraction();
		}
	}
	
	static UpdateContent = function()
	{
		// OVERRIDE FUNCTION
	}
	
	static OnFocusLost = function()
	{
		// OVERRIDE FUNCTION
	}
	
	static CheckInteraction = function()
	{
		if (isFocused)
		{
			CheckContentInteraction();
		}
	}
	
	static CheckContentInteraction = function()
	{
		// OVERRIDE FUNCTION
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
		var backgroundAlpha = isFocused ? 1 : 0.8;
		draw_sprite_ext(sprGUIBg, 0, guiPos.X, guiPos.Y, size.w, size.h, 0, c_white, backgroundAlpha);
	}
	
	static DrawContent = function()
	{
		// OVERRIDE FUNCTION
	}
}