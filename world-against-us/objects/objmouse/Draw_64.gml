var mousePosition = MouseGUIPosition();

if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (global.InstanceWeapon != noone)
	{
		if (!is_undefined(global.InstanceWeapon.primaryWeapon))
		{
			var crosshairScale = (global.InstanceWeapon.isAiming) ? 0.2 : 0.3;
		
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
	if (!is_undefined(dragItem))
	{
		var dragItemData = dragItem.item_data;
		DrawItem(
			dragItemData, 0, 1, 1,
			mousePosition,
			new Size(
				dragItemData.size.w * dragItemIconMaxBaseSize.w,
				dragItemData.size.h * dragItemIconMaxBaseSize.h
			)
		);
	}
	
	// DEBUG MODE
	if (global.DEBUGMODE)
	{
		draw_set_color(c_yellow);
		draw_text(mousePosition.X + 10, mousePosition.Y + 10, string(mousePosition.X) + " : " + string(mousePosition.Y));
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}