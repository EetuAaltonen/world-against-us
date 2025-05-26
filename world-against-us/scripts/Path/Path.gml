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
	
	static ClearPathPoints = function()
	{
		if (path_exists(path))
		{
			path_clear_points(path);
		}
	}
	
	static Draw = function(_pathPosition)
	{
		if (IsPathExist(path))
		{
			var pathPointCount = path_get_number(path);
			var prevPathPointX = undefined;
			var prevPathPointY = undefined;
			for (var i = 0; i < pathPointCount; i++)
			{
				var pointIndex = i / pathPointCount;
				var pointColor = (_pathPosition < pointIndex) ? c_green : c_white;
				var pathPointX = path_get_point_x(path, i);
				var pathPointY = path_get_point_y(path, i);
				
				draw_circle_color(pathPointX, pathPointY, 4, pointColor, pointColor, false);
		
				if (!is_undefined(prevPathPointX) || !is_undefined(prevPathPointY))
				{
					draw_line_color(
						pathPointX, pathPointY,
						prevPathPointX, prevPathPointY,
						c_lime, c_lime
					);
				}
				prevPathPointX = pathPointX;
				prevPathPointY = pathPointY;
			}
		}
	}
}