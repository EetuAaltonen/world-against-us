function Vector2(_x, _y) constructor
{
	X = _x;
	Y = _y;
	
	static ToJSONStruct = function()
	{
		return {
			X: X,
			Y: Y
		}
	}
	
	static Clone = function()
	{
		return new Vector2(X, Y);
	}
	
	static Rotate = function(_angleDeg)
	{
		var radAngle = degtorad(-_angleDeg);
		var cs = cos(radAngle);
		var sn = sin(radAngle);
		var newX = X * cs - Y * sn;
		var newY = X * sn + Y * cs;
	
		return new Vector2(newX, newY);
	}
}