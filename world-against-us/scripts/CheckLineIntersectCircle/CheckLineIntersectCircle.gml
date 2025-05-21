function CheckLineIntersectCircle(_x1, _y1, _x2, _y2, _cx, _cy, _r)
{
	var dx = _x2 - _x1;
	var dy = _y2 - _y1;
	var fx = _x1 - _cx;
	var fy = _y1 - _cy;
	
	var a = dot_product(dx, dy, dx, dy);
	var b = 2 * dot_product(fx, fy, dx, dy);
	var c = dot_product(fx, fy, fx, fy) - _r * _r ;

	var discriminant = b * b - 4 * a * c;
	if (discriminant < 0)
	{
		// NO INTERSECTION
	} else {
		discriminant = sqrt(discriminant);
		// EITHER SOLUTION MAY BE ON OR OFF THE RAY
		// T1 IS ALWAYS SMALLER VALUE, BECAUSE BOTH DISCRIMINANT AND a ARE NONNEGATIVE
		var t1 = (-b - discriminant) / (2 * a);
		var t2 = (-b + discriminant) / (2 * a);
		
		// HIT CASES:
		// Impale(t1 hit, t2 hit)				-o->
		// Poke(t1 hit, t2 > 1)					--|-->  |
		// ExitWound(t1 < 0, t2 hit)			|  --|->
		
		// MISS CASES:
		// FallShort (t1 > 1, t2 > 1)			->  o
		// Past (t1 < 0, t2 < 0)				o ->
		// CompletelyInside(t1 < 0, t2 > 1)		| -> |
		
		if( t1 >= 0 && t1 <= 1 )
		{
			// t1 IS THE INTERSECTION, AND IT'S CLOSER THAN t2
			// (SINCE t1 USES -b - discriminant)
			// IMPALE, POKE
			return true;
		}
		
		// HERE t1 DIDN'T INTERSECT
		// EITHER STARTED INSIDE THE SPHERE OR COMPLETELY PASS IT
		if( t2 >= 0 && t2 <= 1 )
		{
			// ExitWound
			return true;
		}
		
		// NO intn: FallShort, Past, CompletelyInside
		return false;
	}
}