if (!is_undefined(character))
{
	if (character.total_hp_percent < 100)
	{
		var barScale = ceil(character.total_hp_percent * 0.5);
		draw_sprite_ext(
			sprHpBar, 0,
			x - (barScale * 0.5), y + (sprite_height * 0.5) + 10,
			barScale, 1, 0, c_white, 1
		);
	}
}

if (global.DEBUGMODE)
{
	// DRAW VISION RADIUS
	draw_circle_color(x, y, visionRadius, c_purple, c_purple, true);
	
	// DRAW PATH BLOCKING RADIUS
	draw_circle_color(x, y, pathBlockingRadius, c_black, c_black, true);
	
	// DRAW PATH TO TARGET
	var pathPointCount = path_get_number(pathToTarget);
	var prevPathPoint = undefined;
	for (var i = 0; i < pathPointCount; i++)
	{
		var pointIndex = i / pathPointCount;
		var pointColor = (CeilToTwoDecimals(path_position) == CeilToTwoDecimals(pointIndex)) ? c_white : c_green;
		var pathPoint = new Vector2(
			path_get_x(pathToTarget, pointIndex),
			path_get_y(pathToTarget, pointIndex)
		);
		
		draw_circle_color(pathPoint.X, pathPoint.Y, 4, pointColor, pointColor, false);
		
		if (!is_undefined(prevPathPoint))
		{
			draw_line_color(
				pathPoint.X, pathPoint.Y,
				prevPathPoint.X, prevPathPoint.Y,
				c_lime, c_lime
			);
		}
		
		prevPathPoint = pathPoint;
	}
}
