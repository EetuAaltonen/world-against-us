/// @description Custom RoomStartEvent

// RESET CAMERA PROPERTIES
zoom = baseZoom;
viewSize = viewBaseSize.Clone();
cameraTarget = noone;
camera_set_view_size(view_camera[0], viewSize.w, viewSize.h);