function CheckProjectileToObjectCollision(_projectileInstanceRef, _targetInstanceRef)
{
	var isTargetHit = false;
	if (_projectileInstanceRef.collider == undefined) return isTargetHit;
	if (_projectileInstanceRef.instanceState != _projectileInstanceRef.object_index) return isTargetHit;
	if (_targetInstanceRef.collider == undefined) return isTargetHit;
	if (_targetInstanceRef.instanceState != _targetInstanceRef.object_index) return isTargetHit;
	
	switch (_projectileInstanceRef.collider.collider_type)
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
					isTargetHit = CheckLineIntersectRectangle(
						_projectileInstanceRef.x,
						_projectileInstanceRef.y + _projectileInstanceRef.collider.collision_yoffset,
						_projectileInstanceRef.x + directionalSpeedVector.X,
						_projectileInstanceRef.y + _projectileInstanceRef.collider.collision_yoffset + directionalSpeedVector.Y,
						_targetInstanceRef.bbox_left,
						_targetInstanceRef.bbox_top,
						_targetInstanceRef.bbox_right,
						_targetInstanceRef.bbox_top,
						_targetInstanceRef.bbox_right,
						_targetInstanceRef.bbox_bottom,
						_targetInstanceRef.bbox_left,
						_targetInstanceRef.bbox_bottom
					);
				} break;
				case COLLIDER_TYPE.Circle:
				{
					isTargetHit = CheckLineIntersectCircle(
						_projectileInstanceRef.x,
						_projectileInstanceRef.y + _projectileInstanceRef.collider.collision_yoffset,
						_projectileInstanceRef.x + directionalSpeedVector.X,
						_projectileInstanceRef.y + _projectileInstanceRef.collider.collision_yoffset + directionalSpeedVector.Y,
						_targetInstanceRef.x,
						_targetInstanceRef.y + _targetInstanceRef.collider.collision_yoffset,
						_targetInstanceRef.collider.collision_radius,
					);
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