var travelledDistance = point_distance(x, y, spawnPoint._x, spawnPoint._y);

if (initSpeed) {
	speed = flySpeed;
	flyStepRatio = new Vector2((hspeed / flySpeed), (vspeed / flySpeed));
	initSpeed = true;
}
	
// DESTROY OUTSIDE ROOM OR BEYOND RANGE LIMIT
if ((x < 0 || x > room_width || y < 0 || y > room_height) ||
	travelledDistance > range)
{
	instance_destroy();
}
	
// CHECK COLLISION
if (collision_line(x, y, x + hspeed, y + vspeed, objBlockParent, true, true))
{
	// FIND THE POINT ON THE OBJECT'S SURFACE
	while (!place_meeting(x, y, objBlockParent))
	{
		x += flyStepRatio.X;
		y += flyStepRatio.Y;
	}
		
	var hitCorrection = (sprite_width * 0.5) + (bulletHoleRadius * 2);
	x += hitCorrection * flyStepRatio.X;
	y += hitCorrection * flyStepRatio.Y;
}
	