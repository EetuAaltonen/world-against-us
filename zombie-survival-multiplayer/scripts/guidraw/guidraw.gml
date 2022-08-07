function GUIDrawBox(_xPos, _yPos, _width, _height, _color, _outlineWidth = 0, _outlineColor = undefined)
{
	if (_outlineWidth > 0)
	{
		// DRAW OUTLINE
		_outlineColor = (is_undefined(_outlineColor)) ? c_black : _outlineColor;
		draw_rectangle_color(
			_xPos, _yPos,
			_xPos + _width, _yPos + _height,
			_outlineColor, _outlineColor,
			_outlineColor, _outlineColor, false
		);
	}
	
	// DRAW BOX
	draw_rectangle_color(
		_xPos + _outlineWidth,
		_yPos + _outlineWidth,
		_xPos + _width - _outlineWidth,
		_yPos + _height - _outlineWidth,
		_color, _color, _color, _color, false
	);
}