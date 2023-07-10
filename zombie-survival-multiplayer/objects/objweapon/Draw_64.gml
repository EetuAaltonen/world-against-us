if (global.DEBUGMODE)
{
	if (!is_undefined(primaryWeapon))
	{
		var GUIPos = PositionToGUI(new Vector2(x, y + 100));
		draw_text(GUIPos.X, GUIPos.Y, string(image_angle));
	}
}