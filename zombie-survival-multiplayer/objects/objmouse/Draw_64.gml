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
	// DEBUGGING
	draw_set_color(c_yellow);
	draw_text(mousePosition.X + 10, mousePosition.Y + 10, string(mousePosition.X) + " : " + string(mousePosition.Y));
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
	
	
	if (!is_undefined(dragItem))
	{
		var iconScale = CalculateItemIconScale(dragItem, dragItemIconMaxBaseSize);
		var iconRotation = dragItem.is_rotated ? 90 : 0;
		draw_sprite_ext(
			dragItem.icon, 0,
			mousePosition.X, mousePosition.Y,
			iconScale, iconScale, iconRotation, c_white, 0.4
		);
	}
}