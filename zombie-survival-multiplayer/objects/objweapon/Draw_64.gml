// DRAW DEFAULT POINTER
var drawDefaultPointer = function(_mousePosition) {
	draw_circle_color(_mousePosition.X, _mousePosition.Y, 2, c_ltgray, c_ltgray, false);
}
		
if (!is_undefined(primaryWeapon))
{
	var drawCrosshairLaser = function(_mousePosition) {
		// DRAW CROSSHAIR
		draw_sprite_ext(
			sprCrosshair, 0,
			_mousePosition.X, _mousePosition.Y,
			0.3, 0.3,
			0, c_white, 1 
		);
			
		if (!is_undefined(rotatedWeaponBarrelPos))
		{
			// DRAW WEAPON LASER
			var barrelGUIPos = PositionToGUI(new Vector2(
				x + (rotatedWeaponBarrelPos.X * spriteScale),
				y + (rotatedWeaponBarrelPos.Y * spriteScale)
			));
			draw_line_width_color(
				barrelGUIPos.X, barrelGUIPos.Y,
				_mousePosition.X, _mousePosition.Y, 1, c_red, c_red
			);
		}
	}
	
	if (owner.character.type == CHARACTER_TYPE.PLAYER)
	{
		// CHECK GUI STATE
		if (!global.GUIStateHandler.IsGUIStateClosed()) return;

		var mousePosition = MouseGUIPosition();
		if (isAiming)
		{
			drawCrosshairLaser(mousePosition);
		} else {
			drawDefaultPointer(mousePosition);
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
			if (global.GUIStateHandler.IsGUIStateClosed())
			{
				var mousePosition = MouseGUIPosition();
				drawDefaultPointer(mousePosition);
			}
		}
	}
}
