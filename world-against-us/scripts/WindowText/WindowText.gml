function WindowText(_elementId, _relativePosition, _size, _backgroundColor, _text, _textFont, _textHAlign, _textVAlign, _textColor, _textAlpha) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
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
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}