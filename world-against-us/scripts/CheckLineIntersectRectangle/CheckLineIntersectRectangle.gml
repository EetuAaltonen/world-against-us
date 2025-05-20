function CheckLineIntersectRectangle(_linePoints, _rectanglePoints)
{
	return (
		CheckLineIntersectLine(
			_linePoints.start_point.X, _linePoints.start_point.Y,
			_linePoints.end_point.X, _linePoints.end_point.Y,
			_rectanglePoints.top_left_point.X,
			_rectanglePoints.top_left_point.Y,
			_rectanglePoints.top_right_point.X,
			_rectanglePoints.top_right_point.Y
		) ||
		CheckLineIntersectLine(
			_linePoints.start_point.X, _linePoints.start_point.Y,
			_linePoints.end_point.X, _linePoints.end_point.Y,
			_rectanglePoints.top_right_point.X,
			_rectanglePoints.top_right_point.Y,
			_rectanglePoints.bottom_right_point.X,
			_rectanglePoints.bottom_right_point.Y
		) ||
		CheckLineIntersectLine(
			_linePoints.start_point.X, _linePoints.start_point.Y,
			_linePoints.end_point.X, _linePoints.end_point.Y,
			_rectanglePoints.bottom_right_point.X,
			_rectanglePoints.bottom_right_point.Y,
			_rectanglePoints.bottom_left_point.X,
			_rectanglePoints.bottom_left_point.Y
		) ||
		CheckLineIntersectLine(
			_linePoints.start_point.X, _linePoints.start_point.Y,
			_linePoints.end_point.X, _linePoints.end_point.Y,
			_rectanglePoints.bottom_left_point.X,
			_rectanglePoints.bottom_left_point.Y,
			_rectanglePoints.top_left_point.X,
			_rectanglePoints.top_left_point.Y
		) ||
		(
			point_in_rectangle(
				_linePoints.start_point.X, _linePoints.start_point.Y,
				_rectanglePoints.top_left_point.X, _rectanglePoints.top_left_point.Y,
				_rectanglePoints.top_right_point.X, _rectanglePoints.top_right_point.Y
			) &&
			point_in_rectangle(
				_linePoints.end_point.X, _linePoints.end_point.Y,
				_rectanglePoints.top_left_point.X, _rectanglePoints.top_left_point.Y,
				_rectanglePoints.top_right_point.X, _rectanglePoints.top_right_point.Y
			)
		)
	);
}