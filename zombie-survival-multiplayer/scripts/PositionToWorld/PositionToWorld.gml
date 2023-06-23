function PositionToWorld(_GUIPos) {
	var viewXPos = camera_get_view_x(view_camera[0]);
	var viewYPos = camera_get_view_y(view_camera[0]);
	var viewWidth = camera_get_view_width(view_camera[0]);
	var viewHeight = camera_get_view_height(view_camera[0]);

	var pX = (_GUIPos.X * (viewWidth / global.GUIW)) + viewXPos;
	var pY = (_GUIPos.Y * (viewHeight / global.GUIH)) + viewYPos;
	
	return new Vector2(pX, pY);
}