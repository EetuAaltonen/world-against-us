function CheckLineIntersectLine(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4)
{
	var q = (_y1 - _y3) * (_x4 - _x3) - (_x1 - _x3) * (_y4 - _y3);
	var d = (_x2 - _x1) * (_y4 - _y3) - (_y2 - _y1) * (_x4 - _x3);
	
	if(d == 0 )
	{
		return false;
	}
	
	var r = q / d;
	q = (_y1 - _y3) * (_x2 - _x1) - (_x1 - _x3) * (_y2 - _y1);
	
	var s = q / d;
	if( r < 0 || r > 1 || s < 0 || s > 1 )
	{
		return false;
	}
	return true;
}