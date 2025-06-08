if (instance_exists(global.InstancePlayer))
{
	var playerRef = global.InstancePlayer;
	aimPos.X = mouse_x + abs(playerRef.equipmentOriginOffset.X);
	aimPos.Y = mouse_y + abs(playerRef.equipmentOriginOffset.Y);
}