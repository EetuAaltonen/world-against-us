function CheckCollisionPointOnHitbox(_collisionPoint, _aimAngleLine)
{
	var collisionPointOnHitbox = _collisionPoint.position.Clone();
	if (_collisionPoint.nearest_instance != noone)
	{
		// CHECK THAT EXISTING HITBOX SPRITE IS INITIALIZED
		if (_collisionPoint.nearest_instance.mask_index != _collisionPoint.nearest_instance.ownerInstance.mask_index &&
			_collisionPoint.nearest_instance.mask_index != _collisionPoint.nearest_instance.ownerInstance.sprite_index)
		{
			var sx = _collisionPoint.position.X;
			var sy = _collisionPoint.position.Y;
			var ex = _aimAngleLine.end_point.X;
			var ey = _aimAngleLine.end_point.Y;
			var pn = new Vector2((ex - sx) * 0.1, (ey - sy) * 0.1);
			var p1 = new Vector2(sx, sy);
					
			repeat (10)
			{
				if (instance_position(p1.X, p1.Y, _collisionPoint.nearest_instance) == noone || (p1.X == ex && p1.Y == ey)) break;
						
				collisionPointOnHitbox.X = p1.X;
				collisionPointOnHitbox.Y = p1.Y;
						
				p1.X += pn.X;
				p1.Y += pn.Y;
			}
		} else {
			collisionPointOnHitbox = undefined;
		}
	} else {
		collisionPointOnHitbox = undefined;
	}
	
	return collisionPointOnHitbox;
}