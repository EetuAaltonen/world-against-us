// DRAW DEFAULT POINTER
var drawDefaultPointer = function(_mousePosition) {
	draw_circle_color(_mousePosition.X, _mousePosition.Y, 2, c_ltgray, c_ltgray, false);
}
		
if (!is_undefined(primaryWeapon))
{
	var drawCrosshairLaser = function(_mousePosition) {
		var laserStartPoint = new Vector2(
			x + (rotatedWeaponBarrelPos.X * spriteScale),
			y + (rotatedWeaponBarrelPos.Y * spriteScale)
		);
		var laserEndPoint = PositionToWorld(_mousePosition);
			
		// CHECK COLLISION
		var collisionPoint = CollisionLinePoint(
			new Vector2(laserStartPoint.X, laserStartPoint.Y),
			new Vector2(laserEndPoint.X, laserEndPoint.Y),
			objBlockParent, true, true
		);
		if (collisionPoint.nearest_instance != noone) {
			laserEndPoint.X = collisionPoint.position.X;
			laserEndPoint.Y = collisionPoint.position.Y;
		}
		
		var laserGUIStartPoint = PositionToGUI(laserStartPoint);
		var laserGUIEndPoint = PositionToGUI(laserEndPoint);
		
		if (!is_undefined(rotatedWeaponBarrelPos))
		{
			// DRAW WEAPON LASER
			draw_line_width_color(
				laserGUIStartPoint.X, laserGUIStartPoint.Y,
				laserGUIEndPoint.X, laserGUIEndPoint.Y, 1, c_red, c_red
			);
		}
		
		// DRAW CROSSHAIR
		draw_sprite_ext(
			sprCrosshair, 0,
			laserGUIEndPoint.X, laserGUIEndPoint.Y,
			0.3, 0.3,
			0, c_white, 1 
		);
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
