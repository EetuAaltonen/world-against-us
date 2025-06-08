if (instance_exists(global.InstancePlayer))
{
	draw_line_color(
		mouse_x, mouse_y,
		aimPos.X, aimPos.Y,
		c_white, c_white
	);
	draw_circle_color(
		aimPos.X, aimPos.Y, 3,
		c_white, c_white, true
	);
}