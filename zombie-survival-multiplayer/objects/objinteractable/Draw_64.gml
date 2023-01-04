if (global.GUIStateHandler.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (global.HighlightHandlerRef.highlightedInstanceId == id)
		{
			var textGUIPos = PositionToGUI(new Vector2(x, y - sprite_height - 10));
			var textColor = #ffa600;
		
			draw_set_halign(fa_center);
			draw_set_color(textColor);
		
			draw_text(textGUIPos.X, textGUIPos.Y, interactionText);
		
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}