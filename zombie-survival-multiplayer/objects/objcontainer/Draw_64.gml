// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

if (loot != noone)
{
	if (insideInteractionRange)
	{
		var textGUIPos = PositionToGUI(new Vector2(x, y - 100));
		var textColor = make_colour_rgb(255, 200, 36);
		
		draw_set_halign(fa_center);
		
		draw_text_color(textGUIPos.X, textGUIPos.Y, "Loot", textColor, textColor, textColor, textColor, 1);
		
		draw_set_color(c_black);
		draw_set_halign(fa_left);
	}
}
