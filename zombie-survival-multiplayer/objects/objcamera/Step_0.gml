// CHECK GUI STATE
if (!global.GUIStateHandler.IsGUIStateClosed()) return;

if (cameraTarget != noone)
{
	// Zoom
	var _mouseW = mouse_wheel_down() - mouse_wheel_up();
	cameraZoom = clamp(cameraZoom + (_mouseW * cameraZoomFactor), cameraZoomMin, cameraZoomMax);
	
	var lerpH = lerp(cameraViewWidth, cameraZoom * cameraViewHeight, cameraZoomFactor);
	var newH = clamp(lerpH, 0, room_height);
	var newW = newH * (cameraViewWidth / cameraViewHeight);
	camera_set_view_size(view_camera[0], newW, newH);
	
	// Position
	var gotoX = cameraTarget.x - (cameraViewWidth * 0.5);
	var gotoY = cameraTarget.y - (cameraViewHeight * 0.5);
	gotoX = clamp(gotoX, 0, room_width - cameraViewWidth);
	gotoY = clamp(gotoY, 0, room_height - cameraViewHeight);

	var lerpStep = 1;
	var newX = lerp(x, gotoX, lerpStep);
	var newY = lerp(y, gotoY, lerpStep);

	var offsetX = newX - (newW - cameraViewWidth) * 0.5;
	var offsetY = newY - (newH - cameraViewHeight) * 0.5;
	newX = clamp(offsetX, 0, room_width - newW);
	newY = clamp(offsetY, 0, room_height - newH);
	
	camera_set_view_pos(view_camera[0], newX, newY);
} else {
	if (instance_exists(global.ObjPlayer))
	{
		cameraTarget = global.ObjPlayer;
	}	
}
