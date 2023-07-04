if (muzzleFlashTimer > 0)
{
	draw_sprite_ext(
		sprMuzzleFlash, 0,
		x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y,
		image_xscale, image_yscale,
		image_angle, c_white, 1
	);
}

if (isInCameraView && sprite_index != -1) draw_self();

if (!is_undefined(primaryWeapon))
{
	var drawCrosshairLaser = function(_mousePosition) {
		if (!is_undefined(rotatedWeaponBarrelPos))
		{
			var mouseWorldPosition = PositionToWorld(_mousePosition);
			var laserAimAngleLine = new Vector2Line(
				new Vector2(x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y),
				PositionToWorld(_mousePosition)
			);
			
			// CHECK COLLISION
			var collisionPoint = CheckCollisionLinePoint(
				laserAimAngleLine.start_point, laserAimAngleLine.end_point,
				OBJECTS_TO_HIT, true, true, objPlayer, false
			);
			if (!is_undefined(collisionPoint))
			{
				var collisionPointOnHitbox = CheckCollisionPointOnHitbox(collisionPoint, laserAimAngleLine);
				
				if (!is_undefined(collisionPointOnHitbox))
				{
					laserAimAngleLine.end_point = collisionPointOnHitbox.Clone();
				
					var highlightedTarget = collisionPoint.nearest_instance.ownerInstance;
					global.HighlightHandlerRef.SetHighlightedInstance(highlightedTarget, LAYER_HIGHLIGHT_TARGET);
						
					if (global.ObjHud != noone)
					{
						global.ObjHud.highlightedTargetCollisionPos = new Vector2(
							(collisionPointOnHitbox.X - highlightedTarget.hitboxInstance.bbox_left),
							(collisionPointOnHitbox.Y - highlightedTarget.hitboxInstance.bbox_top)
						);
					}
				} else {
					laserAimAngleLine.end_point = collisionPoint.position.Clone();
					global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
				}
			} else {
				global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
			}
			
			// DEBUG MODE
			if (global.DEBUGMODE)
			{
				draw_line_width_color(
					laserAimAngleLine.start_point.X, laserAimAngleLine.start_point.Y,
					mouseWorldPosition.X, mouseWorldPosition.Y,
					1, c_ltgray, c_ltgray
				);
			}
			
			// DRAW WEAPON LASER
			draw_line_width_color(
				laserAimAngleLine.start_point.X, laserAimAngleLine.start_point.Y,
				laserAimAngleLine.end_point.X, laserAimAngleLine.end_point.Y,
				1, c_red, c_red
			);
		}
	}
	
	if (owner.character.type == CHARACTER_TYPE.PLAYER)
	{
		// CHECK GUI STATE
		if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

		var mousePosition = MouseGUIPosition();
		if (isAiming)
		{
			drawCrosshairLaser(mousePosition);
		} else {
			global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
		}
	} else {
		// TODO: Fix weapon network coding
		/*if (isAiming)
		{
			var mouseGUIPos = PositionToGUI(weapon_aim_pos);
			drawCrosshairLaser(mouseGUIPos.X, mouseGUIPos.Y);
		}*/
	}
}