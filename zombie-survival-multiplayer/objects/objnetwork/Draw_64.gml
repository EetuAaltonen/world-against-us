draw_set_font(font_small);
draw_set_halign(fa_right);

if (!is_undefined(client.clientId))
{	
	draw_text(global.GUIW - 10, 20, "Client ID: " + string(client.clientId));
	draw_text(global.GUIW - 10, 30, string(round(latency)) + "ms");
} else {
	draw_text(global.GUIW - 10, 20, "Connecting to " + string(client.hostAddress) + ":" + string(client.hostPort) + "...");
}

draw_set_font(font_default);
draw_set_halign(fa_left);
