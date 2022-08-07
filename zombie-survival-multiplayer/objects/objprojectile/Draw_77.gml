var travelledDistance = point_distance(x, y, spawnPoint._x, spawnPoint._y);

if(!isBulletHit)
{
	if (initSpeed) { speed = flySpeed; initSpeed = true; }
	
	if ((x < 0 || x > room_width || y < 0 || y > room_height) ||
		travelledDistance > range)
	{
		instance_destroy();
	}
	
	if (collision_line(x, y, x + hspeed, y + vspeed, objBlock, true, true))
	{		
		// Find the point on the object's surface
		var stepXRatio = hspeed / flySpeed;
		var stepYRatio = vspeed / flySpeed;
		
		while (!place_meeting(x, y, objBlock))
		{
			x += stepXRatio;
			y += stepYRatio;
			//x += vnx;
			//y += vny;
		}
		
		var hitCorrection = ((sprite_width + bulletHoleSize) * 0.5);
		x += hitCorrection * stepXRatio;
		y += hitCorrection * stepYRatio;
		
		speed = 0;
		isBulletHit = true;
		bulletHoleTimer = bulletHoleDuration;
	}
}
	