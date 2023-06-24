// CHECK GUI STATE
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (!is_undefined(stock))
{
	if (insideInteractionRange)
	{
		var textGUIPos = PositionToGUI(new Vector2(x, y - (sprite_height * 0.5) - 50));
		var textColor = make_colour_rgb(255, 200, 36);
		
		draw_set_halign(fa_center);
		
		draw_text_color(textGUIPos.X, textGUIPos.Y, "Talk", textColor, textColor, textColor, textColor, 1);
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}
