function WorldPositionToGUI(_vectorRef, _xPos, _yPos)
{
	var viewXPos = global.ObjCamera.viewPosition.X;
	var viewYPos = global.ObjCamera.viewPosition.Y;
	var viewWidth = global.ObjCamera.viewSize.w;
	var viewHeight = global.ObjCamera.viewSize.h;
	
	var pX = (_xPos - viewXPos) * (global.GUIW / viewWidth);
	var pY = (_yPos - viewYPos) * (global.GUIH / viewHeight);
	
	_vectorRef.X = pX;
	_vectorRef.Y = pY;
}