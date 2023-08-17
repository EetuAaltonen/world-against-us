function PositionToGUI(_gamePos) {
	var viewXPos = camera_get_view_x(view_camera[0]);
	var viewYPos = camera_get_view_y(view_camera[0]);
	var viewWidth = camera_get_view_width(view_camera[0]);
	var viewHeight = camera_get_view_height(view_camera[0]);
	
	var pX = (_gamePos.X - viewXPos) * (global.GUIW / viewWidth);
	var pY = (_gamePos.Y - viewYPos) * (global.GUIH / viewHeight);
	
	return new Vector2(pX, pY);
}