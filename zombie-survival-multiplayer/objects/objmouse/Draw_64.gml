var mousePosition = new Vector2(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
draw_set_color(c_yellow);
draw_text(mousePosition.X + 10, mousePosition.Y + 10, string(mousePosition.X) + " : " + string(mousePosition.Y));
draw_set_color(c_black);