function CheckLineIntersectRectangle(_lx1, _ly1, _lx2, _ly2, _rx1, _ry1, _rx2, _ry2, _rx3, _ry3, _rx4, _ry4)
{
	return (
		CheckLineIntersectLine(
			_lx1, _ly1,
			_lx2, _ly2,
			_rx1,_ry1,
			_rx2,_ry2
		) ||
		CheckLineIntersectLine(
			_lx1, _ly1,
			_lx2, _ly2,
			_rx2,_ry2,
			_rx3,_ry3
		) ||
		CheckLineIntersectLine(
			_lx1, _ly1,
			_lx2, _ly2,
			_rx3,_ry3,
			_rx4,_ry4
		) ||
		CheckLineIntersectLine(
			_lx1, _ly1,
			_lx2, _ly2,
			_rx4,_ry4,
			_rx1,_ry1
		) ||
		(
			point_in_rectangle(
				_lx1, _ly1,
				_rx1, _ry1,
				_rx2, _ry2
			) &&
			point_in_rectangle(
				_lx2, _ly2,
				_rx1, _ry1,
				_rx2, _ry2
			)
		)
	);
}