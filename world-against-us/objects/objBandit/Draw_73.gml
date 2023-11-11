if (global.DEBUGMODE)
{
	// DRAW PATH BLOCKING RADIUS
	draw_circle_color(x, y, pathBlockingRadius, c_silver, c_silver, true);
	
	// DRAW TARGET PATH
	if (!is_undefined(targetPath))
	{
		var pathPointCount = path_get_number(targetPath);
		var prevPathPoint = undefined;
		for (var i = 0; i < pathPointCount; i++)
		{
			var pointIndex = i / pathPointCount;
			var pointColor = (CeilToTwoDecimals(path_position) == CeilToTwoDecimals(pointIndex)) ? c_white : c_green;
			var pathPoint = new Vector2(
				path_get_point_x(targetPath, i),
				path_get_point_y(targetPath, i)
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
	
	// DRAW VISION RADIUS
	draw_circle_color(x, y, visionRadius, c_purple, c_purple, true);
}
