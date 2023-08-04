var mousePosition = MouseGUIPosition();

if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (global.ObjWeapon != noone)
	{
		if (!is_undefined(global.ObjWeapon.primaryWeapon))
		{
			var crosshairScale = (global.ObjWeapon.isAiming) ? 0.2 : 0.3;
		
			// DRAW CROSSHAIR
			draw_sprite_ext(
				sprCrosshair, 0,
				mousePosition.X, mousePosition.Y,
				crosshairScale, crosshairScale,
				0, c_white, 1 
			);
		} else {
			draw_circle_color(mousePosition.X, mousePosition.Y, 3, c_ltgray, c_ltgray, false);
		}
	}
} else {
	// DEBUG MODE
	if (global.DEBUGMODE)
	{
		draw_set_color(c_yellow);
		draw_text(mousePosition.X + 10, mousePosition.Y + 10, string(mousePosition.X) + " : " + string(mousePosition.Y));
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
	
	
	if (!is_undefined(dragItem))
	{
		var dragItemData = dragItem.item_data;
		var iconBaseScale = 0.8;
		var iconScale = CalculateItemIconScale(dragItemData, dragItemIconMaxBaseSize) * iconBaseScale;
		var iconRotation = CalculateItemIconRotation(dragItemData.is_rotated);
		draw_sprite_ext(
			dragItemData.icon, 0,
			mousePosition.X, mousePosition.Y,
			iconScale, iconScale, iconRotation, c_white, 0.4
		);
	}
}