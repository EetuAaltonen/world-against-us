// Initialise Viewports
view_enabled = true;
view_visible[0] = true;

viewWidth = 2560;
viewHeight = 1440;

windowWidth = 1280;
windowHeight = 720;


view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = viewWidth;
view_hport[0] = viewHeight;

isCameraCreated = false;
cameraTarget = noone;

var displayWidth = display_get_width();
var displayHeight = display_get_height();
var xPos = (displayWidth * 0.5) - (windowWidth * 0.5);
var yPos = (displayHeight * 0.5) - (windowHeight * 0.5);

window_set_rectangle(xPos, yPos, windowWidth, windowHeight);
surface_resize(application_surface, viewWidth, viewHeight);