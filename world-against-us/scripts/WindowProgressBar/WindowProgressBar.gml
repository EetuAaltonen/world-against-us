function WindowProgressBar(_elementId, _relativePosition, _size, _backgroundColor, _value, _maxValue, _title, _progressBarColor, _titleColor = c_black, _textColor = c_black, _valueAsPercentage = false) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	value = _value;
	maxValue = _maxValue;
	title = _title;
	progressBarColor = _progressBarColor;
	titleColor = _titleColor;
	textColor = _textColor;
	valueAsPercentage = _valueAsPercentage;
	
	static DrawContent = function()
	{
		// PROGRESS BAR
		var progressPercent = value / maxValue;
		var progressBarSize = new Size(size.w * progressPercent, size.h);
		draw_sprite_ext(sprGUIBg, 0, position.X, position.Y, progressBarSize.w, progressBarSize.h, 0, progressBarColor, 1);
		
		draw_set_font(font_small_bold);
		draw_set_color(titleColor);
		
		// TITLE
		if (!is_undefined(title))
		{
			draw_text(position.X, position.Y - 15, string(title));
		}
		
		// VALUE
		draw_set_font(font_small)
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		draw_set_color(textColor);
		
		var valueFormatText = valueAsPercentage ? string("{0}%", (progressPercent * 100)) : string("{0} / {1}", value, maxValue);
		draw_text(position.X + (size.w * 0.5), position.Y + (size.h * 0.5), valueFormatText);
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}