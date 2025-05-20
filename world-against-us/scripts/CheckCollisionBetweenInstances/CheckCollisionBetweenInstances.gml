function CheckCollisionBetweenInstances(_instanceRef, _targetInstanceRef)
{
	var isTargetHit = false;
	if (_instanceRef.collider == undefined) return isTargetHit;
	if (_instanceRef.instanceState != _instanceRef.object_index) return isTargetHit;
	if (_targetInstanceRef.collider == undefined) return isTargetHit;
	if (_targetInstanceRef.instanceState != _targetInstanceRef.object_index) return isTargetHit;
	
	var speedVector = new Vector2(_instanceRef.speed, 0);
	var directionalSpeedVector = speedVector.Rotate(_instanceRef.direction);
	var targetInstanceHeight = _targetInstanceRef.sprite_height;
	
	switch (_instanceRef.collider.collider_type)
	{
		case COLLIDER_TYPE.Bounding_box:
		{
			switch (_targetInstanceRef.collider.collider_type)
			{
				case COLLIDER_TYPE.Bounding_box:
				{
					// TODO: Collision script
				} break;
				case COLLIDER_TYPE.Circle:
				{
					// TODO: Collision script
				} break;
				case COLLIDER_TYPE.Point:
				{
					// TODO: Collision script
				} break;
			}
		} break;
		case COLLIDER_TYPE.Circle:
		{
			switch (_targetInstanceRef.collider.collider_type)
			{
				case COLLIDER_TYPE.Bounding_box:
				{
					// TODO: Collision script
				} break;
				case COLLIDER_TYPE.Circle:
				{
					// TODO: Collision script
				} break;
				case COLLIDER_TYPE.Point:
				{
					// TODO: Collision script
				} break;
			}
		} break;
		case COLLIDER_TYPE.Point:
		{
			switch (_targetInstanceRef.collider.collider_type)
			{
				case COLLIDER_TYPE.Bounding_box:
				{
					// TODO: Collision script
				} break;
				case COLLIDER_TYPE.Circle:
				{
					// CHECK IF INSTANCE FLIES OVER THE TARGET
					if (_instanceRef.z <= targetInstanceHeight)
					{
						isTargetHit = CheckLineCircleIntersect(
							_targetInstanceRef.x,
							_targetInstanceRef.y + _targetInstanceRef.collider.collision_yoffset,
							_targetInstanceRef.collider.collision_radius,
							_instanceRef.x, _instanceRef.y + _instanceRef.collider.collision_yoffset,
							_instanceRef.x + directionalSpeedVector.X,
							_instanceRef.y + directionalSpeedVector.Y
						);
					}
				} break;
				case COLLIDER_TYPE.Point:
				{
					// TODO: Collision script
				} break;
			}
		} break;
	}
	return isTargetHit;
}