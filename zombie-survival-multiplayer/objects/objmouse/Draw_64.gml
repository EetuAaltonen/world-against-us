// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

var mouseX = window_mouse_get_x();
var mouseY = window_mouse_get_y();


if (mouse_check_button(mb_right))
{
	draw_sprite_ext(
		sprCrosshair, 0,
		mouseX, mouseY,
		0.3, 0.3,
		0, c_white, 1 
	);
} else {
	draw_circle_color(
		mouseX, mouseY,
		2, c_yellow, c_yellow, false
	);
}