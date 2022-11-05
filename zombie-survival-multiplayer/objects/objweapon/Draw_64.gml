// DRAW DEFAULT POINTER
var drawDefaultPointer = function(_mouseX, _mouseY) {
	draw_circle_color(_mouseX, _mouseY, 2, c_ltgray, c_ltgray, false);
}
		
if (!is_undefined(primaryWeapon))
{
	var drawCrosshairLaser = function(_mouseX, _mouseY) {
		// DRAW CROSSHAIR
		draw_sprite_ext(
			sprCrosshair, 0,
			_mouseX, _mouseY,
			0.3, 0.3,
			0, c_white, 1 
		);
			
		if (!is_undefined(rotatedWeaponBarrelPos))
		{
			// DRAW WEAPON LASER
			var barrelGUIPos = PositionToGUI(new Vector2(
				x + rotatedWeaponBarrelPos.X,
				y + rotatedWeaponBarrelPos.Y
			));
			draw_line_width_color(
				barrelGUIPos.X, barrelGUIPos.Y,
				_mouseX, _mouseY, 1, c_red, c_red
			);
		}
	}
	
	if (owner.character.type == CHARACTER_TYPE.PLAYER)
	{
		// CHECK GUI STATE
		if (!IsGUIStateClosed()) return;

		var mouseX = window_mouse_get_x();
		var mouseY = window_mouse_get_y();
		
		if (isAiming)
		{
			drawCrosshairLaser(mouseX, mouseY);
		} else {
			drawDefaultPointer(mouseX, mouseY);
		}
	} else {
		if (isAiming)
		{
			var mouseGUIPos = PositionToGUI(weapon_aim_pos);
			drawCrosshairLaser(mouseGUIPos.X, mouseGUIPos.Y);
		}
	}
} else {
	if (owner != noone)
	{
		if (owner.character.type == CHARACTER_TYPE.PLAYER)
		{
			// CHECK GUI STATE
			if (!IsGUIStateClosed()) return;	
			
			var mouseX = window_mouse_get_x();
			var mouseY = window_mouse_get_y();
			
			drawDefaultPointer(mouseX, mouseY);
		}
	}
}
