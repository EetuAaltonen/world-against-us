if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (!is_undefined(interactionFunction))
	{
		if (global.HighlightHandlerRef.highlightedInstanceId == id)
		{
			var textGUIPos = PositionToGUI(new Vector2(x, y - sprite_yoffset - 25));
			var textColor = #ffe900;
			
			draw_set_halign(fa_center);
			draw_set_color(textColor);
			draw_set_font(font_default_bold);
			
			draw_text(textGUIPos.X, textGUIPos.Y, interactionText);
		
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}