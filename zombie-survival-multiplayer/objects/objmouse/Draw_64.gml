// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

var mouseX = window_mouse_get_x();
var mouseY = window_mouse_get_y();

// DRAW DEFAULT POINTER
var drawDefaultPointer = function(_mouseX, _mouseY) { draw_circle_color(_mouseX, _mouseY, 2, c_ltgray, c_ltgray, false); }

if (global.ObjGun != noone)
{
	if (global.ObjGun.primaryWeapon != noone && global.ObjGun.isAiming)
	{
		// DRAW CROSSHAIR
		draw_sprite_ext(
			sprCrosshair, 0,
			mouseX, mouseY,
			0.3, 0.3,
			0, c_white, 1 
		);
			
		if (!is_undefined(global.ObjGun.rotatedWeaponBarrelPos))
		{
			// DRAW WEAPON LASER
			var barrelGUIPos = PositionToGUI(new Vector2(
				global.ObjGun.x + global.ObjGun.rotatedWeaponBarrelPos.X,
				global.ObjGun.y + global.ObjGun.rotatedWeaponBarrelPos.Y
			));
			draw_line_width_color(
				barrelGUIPos.X, barrelGUIPos.Y,
				mouseX, mouseY, 1, c_red, c_red
			);
		}
	} else {
		drawDefaultPointer(mouseX, mouseY);
	}
} else {
	drawDefaultPointer(mouseX, mouseY);
}