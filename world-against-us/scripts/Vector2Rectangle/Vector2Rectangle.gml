function Vector2Rectangle(_top_left_point, _top_right_point, _bottom_right_point, _bottom_left_point) constructor
{
	// CLONE VALUES INSTEAD OF REFERRING
	top_left_point = _top_left_point.Clone();
	top_right_point = _top_right_point.Clone();
	bottom_right_point = _bottom_right_point.Clone();
	bottom_left_point = _bottom_left_point.Clone();
	
	static Clone = function()
	{
		return new Vector2Rectangle(
			top_left_point,
			top_right_point,
			bottom_right_point,
			bottom_left_point
		);
	}
	
	static Draw = function(_lineWidth, _lineColor)
	{
		var topLine = new Vector2Line(
			top_left_point,
			top_right_point
		);
		var rightLine = new Vector2Line(
			top_right_point,
			bottom_right_point
		);
		var bottomLine = new Vector2Line(
			bottom_right_point,
			bottom_left_point
		);
		var leftLine = new Vector2Line(
			top_left_point,
			bottom_left_point
		);
		
		draw_line_width_color(
			topLine.start_point.X, topLine.start_point.Y,
			topLine.end_point.X, topLine.end_point.Y,
			_lineWidth, _lineColor, _lineColor
		);
		draw_line_width_color(
			rightLine.start_point.X, rightLine.start_point.Y,
			rightLine.end_point.X, rightLine.end_point.Y,
			_lineWidth, _lineColor, _lineColor
		);
		draw_line_width_color(
			bottomLine.start_point.X, bottomLine.start_point.Y,
			bottomLine.end_point.X, bottomLine.end_point.Y,
			_lineWidth, _lineColor, _lineColor
		);
		draw_line_width_color(
			leftLine.start_point.X, leftLine.start_point.Y,
			leftLine.end_point.X, leftLine.end_point.Y,
			_lineWidth, _lineColor, _lineColor
		);
		draw_line_width_color(
			bottomLine.end_point.X, bottomLine.end_point.Y,
			topLine.end_point.X, topLine.end_point.Y,
			_lineWidth, _lineColor, _lineColor
		);
	}
}