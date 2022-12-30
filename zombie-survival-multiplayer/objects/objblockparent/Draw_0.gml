draw_self();

for (var i = 0; i < ds_list_size(bulletHoles); i++)
{
	// DRAW BULLET HOLE
	var bullet = bulletHoles[| i];
	draw_circle_color(
		bullet.Position.X, bullet.Position.Y,
		bullet.Radius, c_black, c_black, false
	);
	
	// DELETE BULLET HOLE
	if (bullet.Duration-- < 0)
	{
		// REVERSE INDEX AFTER ENTITY DELETION
		ds_list_delete(bulletHoles, i--);
	}
}