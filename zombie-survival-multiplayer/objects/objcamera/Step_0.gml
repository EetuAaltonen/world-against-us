// CHECK GUI STATE
if (!global.GUIStateHandler.IsGUIStateClosed()) return;

if (target != noone)
{
	// Zoom
	var mousScrollUp = (mouse_wheel_up() != 0);
	var mousScrollDown = (mouse_wheel_down() != 0);
	var mouseScrollInput = mousScrollDown - mousScrollUp;
	if (mouseScrollInput != 0)
	{
		zoom = clamp(zoom + (mouseScrollInput * zoomInputStep), minZoom, maxZoom);
	}
	viewSize.w = lerp(viewSize.w, zoom * viewBaseSize.w, viewZoomStep);
	viewSize.h = lerp(viewSize.h, zoom * viewBaseSize.h, viewZoomStep);
	camera_set_view_size(view_camera[0], viewSize.w, viewSize.h);
	
	// Position
	viewPosition.X = lerp(viewPosition.X, target.x - (viewSize.w * 0.5), 1);
	viewPosition.Y = lerp(viewPosition.Y, target.y - (viewSize.h * 0.5), 1);
	camera_set_view_pos(view_camera[0], viewPosition.X, viewPosition.Y);
} else {
	if (instance_exists(global.ObjPlayer))
	{
		target = global.ObjPlayer;
	}	
}