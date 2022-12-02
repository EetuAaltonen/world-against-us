if (recenterWindow)
{
	recenterWindow = false;
	alarm[0] = 10;
}

if (keyboard_check_released(ord("Q")))
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
			
			// RECENTER
			alarm[0] = 10;
		}
	}
}