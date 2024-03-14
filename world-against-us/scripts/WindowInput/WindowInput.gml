function WindowInput(_elementId, _relativePosition, _size, _backgroundColor, _placeholder, _maxInputLength) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	placeholder = _placeholder;
	input = placeholder;
	max_input_length = _maxInputLength;
	
	isTyping = false;
	
	static CheckInteraction = function()
	{
		if (mouse_check_button_released(mb_left))
		{
			if (isHovered && !isTyping)
			{
				if (input == placeholder) { input = EMPTY_STRING; }
				keyboard_string = string(input);
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
				keyboard_string = EMPTY_STRING;
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
					var combinedString = string("{0}{1}", input, clipboard_get_text());
					if (string_length(combinedString) <= max_input_length)
					{
						input = combinedString;
					}
					keyboard_string = string(input);
				}
			} else if (keyboard_check(vk_anykey))
			{
				if (string_length(keyboard_string) <= max_input_length)
				{
					input = string_lower(string(keyboard_string));
					keyboard_string = string(input);
				} else {
					keyboard_string = string(input);
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		var textPadding = 20;
		var textColor = (isTyping) ? c_black : c_dkgray;
		var textToDraw = string(input);
		if ((string_width(string(input)) + (textPadding * 2)) > size.w)
		{
			var textLength = string_length(textToDraw);
			textToDraw = string("...{0}", string_copy(textToDraw, max(1, (textLength - 24)), max_input_length));
		}
		draw_text_color(
			position.X + textPadding, position.Y + (size.h * 0.5),
			textToDraw,
			textColor, textColor, textColor, textColor, 1
		);
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}