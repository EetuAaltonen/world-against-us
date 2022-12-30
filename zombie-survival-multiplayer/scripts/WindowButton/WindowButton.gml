function WindowButton(_elementId, _relativePosition, _size, _backgroundColor, _title, _buttonStyle, _callbackFunction) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	title = _title;
	buttonStyle = _buttonStyle;
	callbackFunction = _callbackFunction;
	
	static CheckInteraction = function()
	{
		backgroundColor = merge_color(buttonStyle.color, buttonStyle.hoverColor, hoverAnimation);
		
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
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(buttonStyle.textFont);
		
		draw_text(position.X + (size.w * 0.5), position.Y + (size.h * 0.5), string(title));
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}