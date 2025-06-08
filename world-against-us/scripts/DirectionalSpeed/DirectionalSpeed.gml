function DirectionalSpeed(_hSpeed, _vSpeed) constructor
{
	h_speed = _hSpeed;
	v_speed = _vSpeed;
	dir = point_direction(0, 0, h_speed, v_speed);
	prev_pos = new Vector2(0, 0);
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(prev_pos);
		prev_pos = undefined;
	}
	
	static Update = function(_instanceRef)
	{
		h_speed = _instanceRef.x - prev_pos.X;
		v_speed = _instanceRef.y - prev_pos.Y;
		dir = point_direction(0, 0, h_speed, v_speed);
		prev_pos.X = _instanceRef.x;
		prev_pos.Y = _instanceRef.y;
	}
}