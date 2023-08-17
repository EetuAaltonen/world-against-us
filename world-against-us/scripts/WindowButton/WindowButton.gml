function WindowButton(_elementId, _relativePosition, _size, _backgroundColor, _title, _buttonStyle, _callbackFunction, _metadata = undefined) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	title = _title;
	buttonStyle = _buttonStyle;
	callbackFunction = _callbackFunction;
	metadata = _metadata;
	
	static CheckInteraction = function()
	{
		if (!is_undefined(buttonStyle.button_background_color) && !is_undefined(buttonStyle.button_background_hover_color))
		{
			backgroundColor = merge_color(buttonStyle.button_background_color, buttonStyle.button_background_hover_color, hoverAnimation);
		}
		
		if (isHovered)
		{
			if (mouse_check_button_released(mb_left))
			{
				callbackFunction();
			}
		}
	}
	
	static DrawContent = function()
	{
		draw_set_halign(buttonStyle.text_h_align);
		draw_set_valign(buttonStyle.text_v_align);
		draw_set_font(buttonStyle.text_font);
		if (isHovered) {
			draw_set_color(buttonStyle.text_hover_color);
		} else {
			draw_set_color(buttonStyle.text_color);	
		}
		
		textOffset = new Vector2(0, 0);
		if (buttonStyle.text_h_align == fa_center)
		{
			textOffset.X = size.w * 0.5;
		} else if (buttonStyle.text_h_align == fa_right)
		{
			textOffset.X = size.w;
		}
		if (buttonStyle.text_v_align == fa_middle)
		{
			textOffset.Y = size.h * 0.5;
		} else if (buttonStyle.text_v_align == fa_bottom)
		{
			textOffset.Y = size.h;
		}
		
		draw_text(position.X + textOffset.X, position.Y + textOffset.Y, string(title));
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}