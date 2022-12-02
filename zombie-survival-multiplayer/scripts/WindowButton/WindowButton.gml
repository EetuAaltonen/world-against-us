function WindowButton(_elementId, _position, _size, _backgroundColor, _title, _callbackFunction) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	title = _title;
	callbackFunction = _callbackFunction;
	
	static CheckInteraction = function()
	{
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
		
		draw_text(position.X + (size.w * 0.5), position.Y + (size.h * 0.5), string(title));
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}