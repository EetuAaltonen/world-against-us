function WindowInput(_elementId, _relativePosition, _size, _backgroundColor, _placeholder) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	placeholder = _placeholder;
	input = placeholder;
	
	isTyping = false;
	
	static CheckInteraction = function()
	{
		if (mouse_check_button_released(mb_left))
		{
			if (isHovered && !isTyping)
			{
				if (input == placeholder) { input = EMPTY_STRING; }
				keyboard_string = input;
				isTyping = true;
			}
		} if (mouse_check_button_pressed(mb_left))
		{
			if (!isHovered && isTyping)
			{
				if (input == EMPTY_STRING) { input = placeholder; }
				keyboard_string = EMPTY_STRING;
				isTyping = false;
			}
		} else if (mouse_check_button_released(mb_right))
		{
			if (isHovered && isTyping)
			{
				input = EMPTY_STRING;
				keyboard_string = input;
			}
		}
		
		if (isTyping)
		{
			if (keyboard_check(vk_control) && keyboard_check_released(ord("C")))
			{
				clipboard_set_text(input);
			} else if (keyboard_check(vk_control) && keyboard_check_released(ord("V")))
			{
				if (clipboard_has_text())
				{
				    input += string_lower(clipboard_get_text());
					keyboard_string = input;
				}
			} else if (keyboard_check(vk_anykey))
			{
				input = string_lower(keyboard_string);
				keyboard_string = input;
			}
		}
	}
	
	static DrawContent = function()
	{
		draw_set_valign(fa_middle);
		
		var textColor = (isTyping) ? c_black : c_dkgray;
		draw_text_color(
			position.X + 20, position.Y + (size.h * 0.5),
			string(input),
			textColor, textColor, textColor, textColor, 1
		);
		
		draw_set_valign(fa_top);
	}
}