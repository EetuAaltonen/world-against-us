var mousePosition = MouseGUIPosition();
draw_set_color(c_yellow);
draw_text(mousePosition.X + 10, mousePosition.Y + 10, string(mousePosition.X) + " : " + string(mousePosition.Y));
draw_set_color(c_black);

if (!is_undefined(dragItem))
{
	var iconScale = CalculateItemIconScale(dragItem, dragItemIconMaxBaseSize);
	var iconRotation = dragItem.is_rotated ? 90 : 0;
	draw_sprite_ext(
		dragItem.icon, 0,
		mousePosition.X, mousePosition.Y,
		iconScale, iconScale, iconRotation, c_white, 0.4
	);
}