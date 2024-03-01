function GameWindowHandler() constructor
{
	gameWindows = ds_list_create();
	focusedWindow = undefined;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(gameWindows);
		gameWindows = undefined;
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
	
	static GetTopMostWindow = function()
	{
		var topMostWindow = undefined;
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			var openWindowCount = array_length(currentGUIState.windowGroup);
			for (var i = 0; i < openWindowCount; i++)
			{
				var openWindow = currentGUIState.windowGroup[@ i];
				if (!is_undefined(openWindow))
				{
					if (is_undefined(topMostWindow))
					{
						topMostWindow = openWindow;
					} else {
						if (openWindow.zIndex < topMostWindow.zIndex)
						{
							topMostWindow = openWindow;	
						}
					}
				}
			}
		}
		return topMostWindow;
	}
	
	static CloseWindowById = function(_windowId)
	{
		var windowCount = ds_list_size(gameWindows);
		for (var i = windowCount - 1; i >= 0; i--)
		{
			var gameWindow = gameWindows[| i];
			if (gameWindow.windowId == _windowId)
			{
				// RESET FOCUSED WINDOW
				if (!is_undefined(focusedWindow))
				{
					if (gameWindow.windowId == focusedWindow.windowId)
					{
						ResetFocusedWindow();
					}
				}
				// CLOSE WINDOW
				gameWindow.OnClose();
				DeleteDSListValueByIndex(gameWindows, i++);
				windowCount = ds_list_size(gameWindows);
				break;
			}
		}
	}
	
	static CloseWindowGroup = function(_windowGroup)
	{
		var isWindowGroupClosed = false;
		var windowCount = array_length(_windowGroup);
		for (var i = 0; i < windowCount; i++)
		{
			var gameWindow = _windowGroup[@ i];
			if (!is_undefined(gameWindow))
			{
				CloseWindowById(gameWindow.windowId);
				isWindowGroupClosed = true;
			}
		}
		return isWindowGroupClosed;
	}
	
	static CloseAllWindows = function()
	{
		var isAllWindowsClosed = true;
		var windowCount = ds_list_size(gameWindows);
		for (var i = 0; i < windowCount; i++)
		{
			var gameWindow = gameWindows[| i];
			// RESET FOCUSED WINDOW
			if (!is_undefined(focusedWindow))
			{
				if (gameWindow.windowId == focusedWindow.windowId)
				{
					ResetFocusedWindow();
				}
			}
			// CLOSE WINDOW
			gameWindow.OnClose();
		}
		ClearDSListAndDeleteValues(gameWindows);
		return isAllWindowsClosed;
	}
	
	static ResetFocusedWindow = function()
	{
		if (!is_undefined(focusedWindow))
		{
			focusedWindow.isFocused = false;
			focusedWindow.OnFocusLost();
			focusedWindow = undefined;
		}
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