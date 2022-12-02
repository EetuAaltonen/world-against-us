// UPDATE FOCUSED WINDOW
var mousePosition = new Vector2(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
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
			focusedWindow.isFocused = false;
			focusedWindow.OnFocusLost();
		}
		
	}
	focusedWindow = newFocusedWindow;
}

// CHECK WINDOW TO CLOSE
if (KeyboardReleasedCloseWindow())
{
	var windowToClose = undefined;
	var windowIndex = undefined;
	var windowCount = ds_list_size(gameWindows);
	for (var i = 0; i < windowCount; i++)
	{
		var window = gameWindows[| i];
		if (window.zIndex < 0)
		{
			if (is_undefined(windowToClose))
			{
				windowToClose = window;
				windowIndex = i;
			} else {
				if (window.zIndex < windowToClose.zIndex)
				{
					windowToClose = window;
					windowIndex = i;
				}
				else if (window.zIndex == windowToClose.zIndex)
				{
					if (window.windowId == focusedWindow.windowId)
					{
						windowToClose = window;
						windowIndex = i;
					}
				}
			}
		}
	}
	
	if (!is_undefined(windowToClose))
	{
		if (!is_undefined(windowIndex))
		{
			ds_list_delete(gameWindows, windowIndex);
		}
	}
}

// UPDATE WINDOWS
var windowCount = ds_list_size(gameWindows);
for (var i = 0; i < windowCount; i++)
{
	var window = gameWindows[| i];
	window.Update();
}
