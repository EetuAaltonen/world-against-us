// CHECK GUI STATE
if (!global.GUIStateHandler.IsGUIStateClosed()) return;

if (insideInteractionRange)
{
	var textGUIPos = PositionToGUI(new Vector2(x, y - sprite_height - 10));
	var textColor = #ffa600;
		
	draw_set_halign(fa_center);
	draw_set_color(textColor);
		
	draw_text(textGUIPos.X, textGUIPos.Y, interactionText);
		
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}