// INHERIT THE PARENT EVENT
event_inherited();
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (!is_undefined(collider))
{
	if (!is_undefined(collider.collision_body))
	{
		if (true || collider.collision_body.hitpoints < collider.collision_body.total_hitpoints)
		{
			draw_set_font(font_small);
			draw_set_halign(fa_center);
			draw_set_color(c_red);
	
			WorldPositionToGUI(guiPos, x, y - z);
			var hpText = "Dead";
			if (collider.collision_body.state == COLLISION_BODY_STATE.ALIVE)
			{
				hpText = string(
					"{0}/{1}",
					collider.collision_body.hitpoints, 
					collider.collision_body.total_hitpoints
				);
			}
			draw_text(guiPos.X, guiPos.Y + 20, hpText);
			draw_text(guiPos.X, guiPos.Y + 40, collider.collision_body.state);

			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}