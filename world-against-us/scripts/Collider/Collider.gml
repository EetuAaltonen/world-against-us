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
		if (collision_body != undefined)
		{
			collision_body.OnDestroy();
			collision_body = undefined;
		}
	}
	
	static Update = function()
	{
		// UPDATE COLLISION BODY
		if (collision_body != undefined)
		{
			collision_body.Update();
		}
	}
	
	static Draw = function(_instanceRef)
	{
		switch (collider_type)
		{
			case COLLIDER_TYPE.Bounding_box:
			{
				if (collision_body != undefined)
				{
					draw_rectangle_color(
						_instanceRef.bbox_left, _instanceRef.bbox_top, 
						_instanceRef.bbox_right, _instanceRef.bbox_bottom,
						c_red, c_red, c_red, c_red,
						true
					);
					// DRAW COLLISION BODY AND HITBOX
					collision_body.Draw();
				}
			} break;
			case COLLIDER_TYPE.Circle:
			{
				draw_circle_color(
					_instanceRef.x, _instanceRef.y + collision_yoffset,
					collision_radius,
					c_red, c_red, true
				);
				
				if (collision_body != undefined)
				{
					// DRAW COLLISION BODY AND HITBOX
					collision_body.Draw(_instanceRef);
				}
			} break;
		}
	}
}