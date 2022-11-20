if (recenterWindow)
{
	recenterWindow = false;
	alarm[0] = 10;
}

if (keyboard_check_released(ord("Q")))
{
	var isFullscreen = window_get_fullscreen();
	window_set_fullscreen(!isFullscreen);
	recenterWindow = true;
}