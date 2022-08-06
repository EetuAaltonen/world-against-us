// Initialise Viewports
view_enabled = true;
view_visible[0] = true;

// Set view
viewWidth = 2560;
viewHeight = 1440;

view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = viewWidth;
view_hport[0] = viewHeight;

// Set camera
cameraViewWidth = 1280;
cameraViewHeight = 720;
cameraTarget = noone;
cameraZoom = 1;
cameraZoomMax = 8;
cameraZoomMin = 1;
cameraZoomFactor = 0.4;

view_camera[0] = camera_create_view(
	0, 0,
	cameraViewWidth, cameraViewHeight,
	0, cameraTarget, -1, -1, 0, 0
);

// Set surface
surface_resize(application_surface, viewWidth, viewHeight);
