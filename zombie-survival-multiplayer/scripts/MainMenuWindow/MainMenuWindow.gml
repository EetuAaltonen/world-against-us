function MainMenuWindow(_windowId, _type, _guiPos, _size, _zIndex, _buttons = undefined) : GameWindow(_windowId, _type, _guiPos, _size, _zIndex) constructor
{
	menuButtons = _buttons;
	buttonSize = new Size(200, 60);
	buttonHoverIndex = undefined;
	initButtons = true;
	
	static UpdateContent = function()
	{
		if (initButtons)
		{
			InitButtons();
		} else {
			// UPDATE BUTTON HOVER INDEX
			UpdateButtonHoverIndex();
		}
	}
	
	static InitButtons = function()
	{
		initButtons = false;
		
		var buttonCount = ds_list_size(menuButtons);
		var buttonMargin = 10;
		var guiSize = new Size(display_get_gui_width(), display_get_gui_height());
		
		for (var i = 0; i < buttonCount; i++)
		{
			var button = menuButtons[| i];
			var buttonPos = new Vector2(
				guiSize.w * 0.5 - (buttonSize.w * 0.5),
				guiSize.h * 0.2 + ((buttonSize.h + buttonMargin) * i)
			);
			var iconScale = new Vector2(
				buttonSize.w / sprite_get_width(button.icon),
				buttonSize.h / sprite_get_height(button.icon)
			);
			
			button.size = buttonSize;
			button.guiPosition = buttonPos;
			button.iconScale = iconScale;
		}
	}
	
	static OnFocusLost = function()
	{
		if (!initButtons)
		{
			CheckContentInteraction();
		}
	}
	
	static UpdateButtonHoverIndex = function()
	{
		if (!initButtons)
		{
			buttonHoverIndex = undefined;
		
			var mouseX = window_mouse_get_x();
			var mouseY = window_mouse_get_y();
			var buttonCount = ds_list_size(menuButtons);
		
			for (var i = 0; i < buttonCount; i++)
			{
				var button = menuButtons[| i];
			
				if (mouseX >= button.guiPosition.X && mouseX <= (button.guiPosition.X + button.size.w) &&
					mouseY >= button.guiPosition.Y && mouseY <= (button.guiPosition.Y + button.size.h))
				{
					button.isHovered = true;
					buttonHoverIndex = i;
				} else {
					button.isHovered = false;
				}
			}
		}
	}
	
	static CheckContentInteraction = function()
	{
		// CHECK FOR INTERACTIONS
		if (!initButtons)
		{
			if (!is_undefined(buttonHoverIndex))
			{
				if (mouse_check_button_released(mb_left))
				{
					var button = menuButtons[| buttonHoverIndex];
					// CALL THE BUTTON FUNCTION
					button.callbackFunction();
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		// DRAW BUTTONS
		if (!initButtons)
		{
			var buttonCount = ds_list_size(menuButtons);
		
			for (var i = 0; i < buttonCount; i++)
			{
				var button = menuButtons[| i];
				var iconIndex = button.isHovered ? 1 : 0;
			
				draw_sprite_ext(
					button.icon, iconIndex,
					button.guiPosition.X, button.guiPosition.Y,
					button.iconScale.X, button.iconScale.Y, 0, c_white, 1
				);
			
				// DRAW BUTTON TITLE
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				draw_text(
					button.guiPosition.X + (button.size.w * 0.5),
					button.guiPosition.Y + (button.size.h * 0.5),
					button.title
				);
			
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			}
		}
	}
}