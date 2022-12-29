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
}