if (instance_exists(global.InstancePlayer))
{
	var playerRef = global.InstancePlayer;
	var mouseWorldPosition = MouseWorldPosition();
	var aimPos = new Vector2(
		mouseWorldPosition.X + abs(playerRef.equipmentOriginOffset.X),
		mouseWorldPosition.Y + abs(playerRef.equipmentOriginOffset.Y)
	);
	draw_line_color(
		mouseWorldPosition.X, mouseWorldPosition.Y,
		aimPos.X, aimPos.Y,
		c_white, c_white
	);
	draw_circle_color(
		aimPos.X, aimPos.Y, 3,
		c_white, c_white, true
	);
}