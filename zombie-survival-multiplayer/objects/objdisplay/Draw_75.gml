if (updateWindow)
{
	updateWindow = false;
	
	var displayWidth = display_get_width();
	var displayHeight = display_get_height();
	var windowXPos = (displayWidth * 0.5) - (windowWidth * 0.5);
	var windowYPos = (displayHeight * 0.5) - (windowHeight * 0.5);
	window_set_rectangle(windowXPos, windowYPos, windowWidth, windowHeight);
	global.GUIW = display_get_gui_width();
	global.GUIH = display_get_gui_height();
}
