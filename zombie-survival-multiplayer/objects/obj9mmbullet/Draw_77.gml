var travelledDistance = point_distance(x, y, spawnPoint._x, spawnPoint._y);

if(!isBulletHit)
{
	if ((x < 0 || x > room_width || y < 0 || y > room_height) ||
		travelledDistance > range)
	{
		instance_destroy();	
	}
	
	if (collision_line(x, y, x + hspeed, y + vspeed, objBlock, true, true))
	{
		var vx = ((x + hspeed) - x);
		var vy = ((y + vspeed) - y);
		var len = sqr(vx + vy);
		// Normalize fly direction vector
		var vnx = (vx / len);
		var vny = (vy / len);
		
		// Find the point on the object's surface
		while (!place_meeting(x, y, objBlock))
		{
			x += vnx;
			y += vny;
		}
		
		speed = 0;
		isBulletHit = true;
	}
}
	