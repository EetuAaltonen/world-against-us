if (recenterWindow)
{
	recenterWindow = false;
	// GAMEMAKER STUDIO REQUIRES A SHORT DELAY
	// BETWEEN WINDOW RESIZING AND WINDOW RECENTER CALLS
	alarm[0] = 10;
}

if (keyboard_check_released(ord("P")))
{
	isFullscreen = !isFullscreen
	window_set_fullscreen(isFullscreen);
} else if (keyboard_check(vk_control))
{
	if (!isFullscreen)
	{
		var newWindowScale = windowScale;
		// SCALE WINDOW
		if (mouse_wheel_up())
		{
			newWindowScale += windowScaleStep;
		} else if (mouse_wheel_down())
		{
			newWindowScale -= windowScaleStep;
		}
		
		if (newWindowScale != windowScale)
		{
			windowScale = newWindowScale;
			
			// SET WINDOW SIZE
			window_set_size(idealDisplayWidth * windowScale, idealDisplayHeight * windowScale);
			// SET APPLICATION SURFACE
			surface_resize(application_surface, idealDisplayWidth * windowScale, idealDisplayHeight * windowScale);
			
			recenterWindow = true;
		}
	}
}


// DEBUG FPS
if (fpsUpdateTimer-- < 0)
{
	fpsReal = fps_real;
	_fps = fps;
	fpsUpdateTimer = fpsUpdateInterval;
}