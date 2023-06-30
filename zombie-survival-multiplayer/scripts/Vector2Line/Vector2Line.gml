function Vector2Line(_start_point, _end_point) constructor
{
	start_point = _start_point;
	end_point = _end_point;
	
	static ToJSONStruct = function()
	{
		
		return {
			start_point: start_point.ToJSONStruct(),
			end_point: end_point.ToJSONStruct()
		}
	}
	
	static Clone = function()
	{
		return new Vector2Line(
			start_point,
			end_point
		);
	}
}