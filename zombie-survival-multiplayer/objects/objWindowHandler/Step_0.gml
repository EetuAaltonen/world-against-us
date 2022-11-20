// UPDATE FOCUSED WINDOW
var mouseX = window_mouse_get_x();
var mouseY = window_mouse_get_y();
var newFocusedWindow = undefined;

var windowCount = ds_list_size(gameWindows);
for (var i = 0; i < windowCount; i++)
{
	var window = gameWindows[| i];
	
	if (mouseX >= window.guiPos.X && mouseX <= (window.guiPos.X + window.size.w) &&
		mouseY >= window.guiPos.Y && mouseY <= (window.guiPos.Y + window.size.h))
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
if (keyboard_check_released(vk_tab) ||
	keyboard_check_released(vk_escape))
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

// INTERACTIONS OUT OF WINDOWS
// RESET DRAGGED ITEM IF DROPPED OUT OF WINDOW
if (mouse_check_button_released(mb_left))
{
	if (!is_undefined(global.DragItem))
	{
		if (is_undefined(focusedWindow))
		{
			global.DragItem = undefined;
		} else {
			if (focusedWindow.type != GAME_WINDOW_TYPE.PlayerBackpack &&
				focusedWindow.type != GAME_WINDOW_TYPE.LootContainer)
			{
				global.DragItem = undefined;	
			}
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

