function GameWindowHandler() constructor
{
	gameWindows = ds_list_create();
	focusedWindow = undefined;
	
	static OpenWindowGroup = function(_windowGroup)
	{
		var windowCount = array_length(_windowGroup);
		for (var i = 0; i < windowCount; i++)
		{
			var gameWindow = _windowGroup[@ i];
			ds_list_add(gameWindows, gameWindow);
			gameWindow.OnOpen();
		}
	}
	
	static GetWindowById = function(_windowId)
	{
		var window = undefined;
		var windowCount = ds_list_size(gameWindows);
		
		for (var i = windowCount - 1; i >= 0; i--)
		{
			var gameWindow = gameWindows[| i];
			if (gameWindow.windowId == _windowId)
			{
				window = gameWindow;
				break;
			}
		}
		
		return window;
	}
	
	static Update = function()
	{
		UpdateFocusedWindow();
		
		var windowCount = ds_list_size(gameWindows);
		for (var i = 0; i < windowCount; i++)
		{
			var window = gameWindows[| i];
			window.Update();
		}
	}
	
	static UpdateFocusedWindow = function()
	{
		var mousePosition = MouseGUIPosition();
		var newFocusedWindow = undefined;

		var windowCount = ds_list_size(gameWindows);
		for (var i = 0; i < windowCount; i++)
		{
			var window = gameWindows[| i];
	
			if (point_in_rectangle(mousePosition.X, mousePosition.Y, window.position.X, window.position.Y, (window.position.X + window.size.w), (window.position.Y + window.size.h)))
			{
				if (!is_undefined(newFocusedWindow))
				{
					if (window.zIndex < newFocusedWindow.zIndex)
					{
						newFocusedWindow = window;
					}
				} else {
					newFocusedWindow = window;
				}
			} else {
				if (window.isFocused)
				{
					window.isFocused = false;
					window.OnFocusLost();
			
					focusedWindow = undefined;
				}
			}
		}

		if (!is_undefined(newFocusedWindow))
		{
			newFocusedWindow.isFocused = true;
	
			if (!is_undefined(focusedWindow))
			{
				if (newFocusedWindow.windowId != focusedWindow.windowId)
				{
					ResetFocusedWindow();
				}
			}
			focusedWindow = newFocusedWindow;
		}
	}
	
	static CloseWindowById = function(_windowId)
	{
		var windowCount = ds_list_size(gameWindows);
		for (var i = windowCount - 1; i >= 0; i--)
		{
			var gameWindow = gameWindows[| i];
			if (gameWindow.windowId == _windowId)
			{
				// CLOSE WINDOW
				gameWindow.OnClose();
				ds_list_delete(gameWindows, i++);
				windowCount = ds_list_size(gameWindows);
				break;
			}
		}
	}
	
	static CloseWindowGroupByIndexGroup = function(_windowIndexGroup)
	{
		var isWindowGroupClosed = false;
		var windowCount = array_length(_windowIndexGroup);
		for (var i = 0; i < windowCount; i++)
		{ 
			CloseWindowById(_windowIndexGroup[@ i]);
			isWindowGroupClosed = true;
		}
		return isWindowGroupClosed;
	}
	
	static CloseAllWindows = function()
	{
		var windowCount = ds_list_size(gameWindows);
		for (var i = 0; i < windowCount; i++)
		{
			var gameWindow = gameWindows[| i];
			gameWindow.OnClose();
		}
		ds_list_clear(gameWindows);
		
		// RESET FOCUSED
		if (!is_undefined(focusedWindow))
		{
			ResetFocusedWindow();	
		}
	}
	
	static ResetFocusedWindow = function()
	{
		focusedWindow.isFocused = false;
		focusedWindow.OnFocusLost();
		focusedWindow = undefined;
	}
	
	static Draw = function()
	{
		var windowCount = ds_list_size(gameWindows);
		for (var i = 0; i < windowCount; i++)
		{
			var window = gameWindows[| i];
			window.Draw();
		}
	}
}