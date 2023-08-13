function MouseGUIPosition()
{
	var mouseGUIPosition = new Vector2(
		device_mouse_x_to_gui(0),
		device_mouse_y_to_gui(0)
	);
	return mouseGUIPosition;
}