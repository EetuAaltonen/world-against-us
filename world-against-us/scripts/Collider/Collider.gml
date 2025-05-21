function Collider(_colliderType, _collisionRadius = 0, _collisionYOffset = 0, _collisionBody = undefined) constructor
{
	collider_type = _colliderType;
	// POINT COLLIDERS DON'T NEED COLLISION BODY
	collision_body = _collisionBody;
	// USED WITH CIRCLE COLLIDER
	collision_radius = _collisionRadius;
	// NEGATIVE IS UP
	collision_yoffset = _collisionYOffset;
	
	static OnDestroy = function()
	{
		if (!is_undefined(collision_body))
		{
			collision_body.OnDestroy();
			collision_body = undefined;
		}
	}
	
	static Update = function()
	{
		// UPDATE COLLISION BODY
		if (!is_undefined(collision_body))
		{
			collision_body.Update();
		}
	}
	
	static Draw = function(_instanceRef)
	{
		var outlineColor = c_blue;
		switch (collider_type)
		{
			case COLLIDER_TYPE.Bounding_box:
			{
				draw_rectangle_color(
					_instanceRef.bbox_left, _instanceRef.bbox_top, 
					_instanceRef.bbox_right, _instanceRef.bbox_bottom,
					outlineColor, outlineColor, outlineColor, outlineColor,
					true
				);
			} break;
			case COLLIDER_TYPE.Circle:
			{
				draw_circle_color(
					_instanceRef.x, _instanceRef.y + collision_yoffset,
					collision_radius,
					outlineColor, outlineColor, true
				);
			} break;
		}
		
		// DRAW COLLISION BODY
		if (!is_undefined(collision_body))
		{
			collision_body.Draw(_instanceRef);
		}
	}
}