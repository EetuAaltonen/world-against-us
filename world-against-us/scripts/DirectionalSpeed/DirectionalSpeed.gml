function DirectionalSpeed(_hSpeed, _vSpeed) constructor
{
	h_speed = _hSpeed;
	v_speed = _vSpeed;
	dir = point_direction(0, 0, h_speed, v_speed);
	prev_pos = new Vector2(-1, -1);
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(prev_pos);
		prev_pos = undefined;
	}
	
	static Update = function(_instanceRef)
	{
		if (prev_pos.X > -1 && prev_pos.Y > -1)
		{
			h_speed = _instanceRef.x - prev_pos.X;
			v_speed = _instanceRef.y - prev_pos.Y;
			dir = point_direction(0, 0, h_speed, v_speed);
		}
		prev_pos.X = _instanceRef.x;
		prev_pos.Y = _instanceRef.y;
	}
}