// Set default draw properties
draw_set_font(font_default);
draw_set_color(c_black);
draw_set_alpha(1);

// Set window
updateWindow = false;
windowWidth = 1280;
windowHeight = 720;

var displayWidth = display_get_width();
var displayHeight = display_get_height();
var windowXPos = (displayWidth * 0.5) - (windowWidth * 0.5);
var windowYPos = (displayHeight * 0.5) - (windowHeight * 0.5);
window_set_rectangle(windowXPos, windowYPos, windowWidth, windowHeight);

// Set GUI size
display_set_gui_size(windowWidth, windowHeight);
