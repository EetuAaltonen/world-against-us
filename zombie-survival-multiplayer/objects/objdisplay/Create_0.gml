// DISPLAY PROPERTIES
idealDisplayWidth = 640;
idealDisplayHeight = 360;
windowScale = 1;
windowScaleStep = 0.25;

idealGUIWidth = 1920;
idealGUIHeight = 1080;

isFullscreen = window_get_fullscreen();

displayWidth = display_get_width();
displayHeight = display_get_height();
aspectRatio = displayWidth / displayHeight;

// CALCULATE DISPLAY WIDTH
//idealDisplayWidth = idealDisplayHeight * aspectRatio;

// WINDOW RECENTER
recenterWindow = false;

// PERFECT PIXEL SCALING
/*if (displayWidth mod idealDisplayWidth != 0)
{
	var d = round(displayWidth / idealDisplayWidth);
	idealDisplayWidth = displayWidth / d;
}
if (displayHeight mod idealDisplayHeight != 0)
{
	var d = round(displayHeight / idealDisplayHeight);
	idealDisplayHeight = displayHeight / d;
}*/

// CHECK FOR ODD NUMERS
//if (idealDisplayWidth & 1) idealDisplayWidth++;
//if (idealDisplayHeight & 1) idealDisplayHeight++;

// SET VIEWS TO ROOMS
for (var i = 1; i < room_last; i++)
{
	if (room_exists(i))
	{
		room_set_viewport(i, 0, true, 0, 0, idealDisplayWidth, idealDisplayHeight);
		room_set_view_enabled(i, true);
	}
}

// CALCULATE WINDOW SCALE
while (true)
{
	var newWindowScale = windowScale + 1;
	var newWindowSize = new Size(idealDisplayWidth * newWindowScale , idealDisplayHeight * newWindowScale);
	if (newWindowSize.w > displayWidth ||  newWindowSize.h > displayHeight) break;
	windowScale++;
}

// SET WINDOW SIZE
window_set_size(idealDisplayWidth * windowScale, idealDisplayHeight * windowScale);

// SET APPLICATION SURFACE
surface_resize(application_surface, idealDisplayWidth * windowScale, idealDisplayHeight * windowScale);

// Set GUI SIZE
display_set_gui_size(idealGUIWidth, idealGUIHeight);

// SET DEFAULT DRAW PROPERTIES
draw_set_font(font_default);
draw_set_color(c_black);
draw_set_alpha(1);