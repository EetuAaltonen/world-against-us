function WorldPositionToGUI(_vectorRef, _xPos, _yPos)
{
	var viewXPos = camera_get_view_x(view_camera[0]);
	var viewYPos = camera_get_view_y(view_camera[0]);
	var viewWidth = camera_get_view_width(view_camera[0]);
	var viewHeight = camera_get_view_height(view_camera[0]);
	
	var pX = (_xPos - viewXPos) * (global.GUIW / viewWidth);
	var pY = (_yPos - viewYPos) * (global.GUIH / viewHeight);
	
	_vectorRef.X = pX;
	_vectorRef.Y = pY;
}