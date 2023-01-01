// CHECK GUI STATE
if (!global.GUIStateHandler.IsGUIStateClosed()) return;

if (insideInteractionRange)
{
	var textGUIPos = PositionToGUI(new Vector2(x, y - 100));
	var textColor = make_colour_rgb(255, 200, 36);
		
	draw_set_halign(fa_center);
		
	draw_text_color(textGUIPos.X, textGUIPos.Y, "Loot", textColor, textColor, textColor, textColor, 1);
		
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}