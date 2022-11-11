var windowCount = ds_list_size(gameWindows);

// UPDATE FOCUSED WINDOW
var mouseX = window_mouse_get_x();
var mouseY = window_mouse_get_y();
var newFocusedWindow = undefined;

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
for (var i = 0; i < windowCount; i++)
{
	var window = gameWindows[| i];
	window.Update();
}

