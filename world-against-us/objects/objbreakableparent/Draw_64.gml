// INHERIT THE PARENT EVENT
event_inherited();
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (collider != undefined)
{
	if (collider.collision_body != undefined)
	{
		draw_set_font(font_small);
		draw_set_halign(fa_center);
		draw_set_color(c_red);
	
		var guiPos = PositionToGUI(new Vector2(x, y - z));
		draw_text(
			guiPos.X, guiPos.Y + 20,
			string(
				"{0}/{1}",
				collider.collision_body.hitpoints, 
				collider.collision_body.total_hitpoints
			)
		);

		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}