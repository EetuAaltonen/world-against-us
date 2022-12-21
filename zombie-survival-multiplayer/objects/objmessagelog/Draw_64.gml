var messageCount = ds_list_size(messages);
if (messageCount > 0)
{
	var textPos = new Vector2(
		(global.GUIW * 0.5),
		(100 * (1 - (displayTimer / displayDuration)))
	);
		
	draw_set_color(c_red);
	draw_set_halign(fa_center);
		
	draw_text(textPos.X, textPos.Y, string(messages[| 0]));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}