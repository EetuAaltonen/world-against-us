if (drawHitboxes)
{
	var topLine = new Vector2Line(
		new Vector2(bbox_left, bbox_top),
		new Vector2(bbox_right, bbox_top)
	);
	var rightLine = new Vector2Line(
		new Vector2(bbox_right, bbox_top),
		new Vector2(bbox_right, bbox_bottom)
	);
	var bottomLine = new Vector2Line(
		new Vector2(bbox_left, bbox_bottom),
		new Vector2(bbox_right, bbox_bottom)
	);
	var leftLine = new Vector2Line(
		new Vector2(bbox_left, bbox_top),
		new Vector2(bbox_left, bbox_bottom)
	);
	var lineColor = c_red;
	var lineWidth = 2;
	
	draw_line_width_color(
		topLine.start_point.X, topLine.start_point.Y,
		topLine.end_point.X, topLine.end_point.Y,
		lineWidth, lineColor, lineColor
	);
	draw_line_width_color(
		rightLine.start_point.X, rightLine.start_point.Y,
		rightLine.end_point.X, rightLine.end_point.Y,
		lineWidth, lineColor, lineColor
	);
	draw_line_width_color(
		bottomLine.start_point.X, bottomLine.start_point.Y,
		bottomLine.end_point.X, bottomLine.end_point.Y,
		lineWidth, lineColor, lineColor
	);
	draw_line_width_color(
		leftLine.start_point.X, leftLine.start_point.Y,
		leftLine.end_point.X, leftLine.end_point.Y,
		lineWidth, lineColor, lineColor
	);
	draw_line_width_color(
		bottomLine.start_point.X, bottomLine.start_point.Y,
		topLine.end_point.X, topLine.end_point.Y,
		lineWidth, lineColor, lineColor
	);
}