function WindowText(_elementId, _position, _size, _backgroundColor, _text, _textFont, _textHAlign, _textVAlign, _textColor, _textAlpha) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	text = _text;
	textFont = _textFont;
	textHAlign = _textHAlign;
	textVAlign = _textVAlign;
	textColor = _textColor;
	textAlpha = _textAlpha;
	
	static DrawContent = function()
	{
		draw_set_font(textFont);
		draw_set_halign(textHAlign);
		draw_set_valign(textVAlign);
		
		draw_text_color(position.X, position.Y, string(text), textColor, textColor, textColor, textColor, textAlpha);
		
		draw_set_font(font_default);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}