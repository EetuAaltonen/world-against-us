// ROOM START AFTER
if (onRoomStartAfter)
{
	onRoomStartAfter = false;
	
	roomGrid = mp_grid_create(0, 0, (room_width / cellSize.X), (room_height / cellSize.Y), cellSize.X, cellSize.Y);
	mp_grid_add_instances(roomGrid, objBlockParent, false);	
}