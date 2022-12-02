draw_set_font(font_small);
draw_set_halign(fa_right);
draw_set_color(c_red);

if (!is_undefined(client.clientId))
{	
	draw_text(global.GUIW - 10, 20, "Client ID: " + string(client.clientId));
	draw_text(global.GUIW - 10, 30, string(round(latency)) + "ms");
}

draw_set_color(c_black);
draw_set_font(font_default);
draw_set_halign(fa_left);
