function DirectionalSpeed(_hSpeed, _vSpeed) constructor
{
	h_speed = _hSpeed;
	v_speed = _vSpeed;
	dir = point_direction(0, 0, h_speed, v_speed);
	prev_pos = new Vector2(-1, -1);
	prev_image_scale = new Vector2(0, 0);
	has_turned = false;
	
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
		
		if (prev_image_scale.X != 0 && prev_image_scale.Y != 0)
		{
			has_turned = (prev_image_scale.X != _instanceRef.image_xscale);
		}
		prev_image_scale.X = _instanceRef.image_xscale;
		prev_image_scale.Y = _instanceRef.image_yscale;
	}
}