var messageCount = ds_list_size(messages);
if (messageCount > 0)
{
	var xPos = (global.GUIW * 0.5);
	var yPos = (100 * (1 - (displayTimer / displayDuration)));
	var msg = ds_list_find_value(messages, 0);
		
	draw_set_color(c_red);
	draw_set_halign(fa_center);
		
	draw_text(xPos, yPos, string(msg));
		
	draw_set_halign(fa_left);
	draw_set_color(c_black);
}