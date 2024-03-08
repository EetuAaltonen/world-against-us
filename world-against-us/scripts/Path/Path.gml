function Path(_path = undefined) constructor
{
	path = _path ?? path_add();
	
	static OnDestroy = function(_struct = self)
	{
		DeletePath(_struct.path);
	}
	
	static CalculatePath = function(_startPositionX, _startPositionY, _endPositionX, _endPositionY, _allowDiagonal)
	{
		var isPathFound = false;
		if (IsPathExist(path))
		{
			isPathFound = mp_grid_path(
				global.ObjGridPath.roomGrid, path,
				_startPositionX, _startPositionY,
				_endPositionX, _endPositionY,
				_allowDiagonal
			);
		}
		return isPathFound;
	}
	
	static CalculatePotentialPath = function(_endPositionX, _endPositionY, _instanceRef, _speed)
	{
		var isPathFound = false;
		var factor = 4;
		if (IsPathExist(path))
		{
			with (_instanceRef)
			{
				isPathFound = mp_potential_path_object(other.path, _endPositionX, _endPositionY, factor, _speed, objBlockParent);
			}
		}
		return isPathFound;
	}
	
	static GetPathPoint = function(_pathPosition)
	{
		var pathPoint = undefined;
		if (IsPathExist(path))
		{
			pathPoint = new Vector2(
				path_get_x(path, _pathPosition),
				path_get_y(path, _pathPosition)
			);
		}
		return pathPoint;
	}
	
	static Draw = function(_pathPosition = 0)
	{
		if (IsPathExist(path))
		{
			var pathPointCount = path_get_number(path);
			var prevPathPoint = undefined;
			for (var i = 0; i < pathPointCount; i++)
			{
				var pointIndex = i / pathPointCount;
				var pointColor = (CeilToTwoDecimals(_pathPosition) == CeilToTwoDecimals(pointIndex)) ? c_white : c_green;
				var pathPoint = new Vector2(
					path_get_point_x(path, i),
					path_get_point_y(path, i)
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
	}
}