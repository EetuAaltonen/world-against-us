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
			var laserStartPoint = new Vector2(
				x + rotatedWeaponBarrelPos.X,
				y + rotatedWeaponBarrelPos.Y
			);
			var laserEndPoint = PositionToWorld(_mousePosition);
			var weaponAimVectorLine = new Vector2Line(laserStartPoint.Clone(), laserEndPoint.Clone());
			
			// CHECK COLLISION
			var collisionPoint = CheckCollisionLinePoint(
				laserStartPoint, laserEndPoint,
				OBJECTS_TO_HIT, true, true, objPlayer
			);
			if (!is_undefined(collisionPoint))
			{
				if (collisionPoint.nearest_instance != noone) {
					laserEndPoint.X = collisionPoint.position.X;
					laserEndPoint.Y = collisionPoint.position.Y;
					var collisionInstanceParent = object_get_parent(collisionPoint.nearest_instance.ownerInstance.object_index);
					if (collisionInstanceParent == objCharacterParent) {
						var sx = collisionPoint.position.X;
						var sy = collisionPoint.position.Y;
						var ex = weaponAimVectorLine.end_point.X;
						var ey = weaponAimVectorLine.end_point.Y;
						var pn = new Vector2((ex - sx) * 0.1, (ey - sy) * 0.1);
						var p1 = new Vector2(sx, sy);
					
						repeat (10)
						{
							if (instance_position(p1.X, p1.Y, collisionPoint.nearest_instance) == noone || (p1.X == ex && p1.Y == ey)) break;
						
							laserEndPoint.X = p1.X;
							laserEndPoint.Y = p1.Y;
						
							p1.X += pn.X;
							p1.Y += pn.Y;
						}
						
						var highlightedTarget = collisionPoint.nearest_instance.ownerInstance;
						global.HighlightHandlerRef.SetHighlightedInstance(collisionPoint.nearest_instance.ownerInstance, LAYER_HIGHLIGHT_TARGET);
						global.HighlightHandlerRef.highlightedTarget = highlightedTarget;
					} else {
						global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
						global.HighlightHandlerRef.highlightedTarget = noone;
					}
				} else {
					global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
					global.HighlightHandlerRef.highlightedTarget = noone;
				}
			} else {
				global.HighlightHandlerRef.ResetHighlightedInstance(LAYER_HIGHLIGHT_TARGET);
				global.HighlightHandlerRef.highlightedTarget = noone;
			}
			
			// DRAW WEAPON LASER
			draw_line_width_color(
				laserStartPoint.X, laserStartPoint.Y,
				weaponAimVectorLine.end_point.X, weaponAimVectorLine.end_point.Y,
				1, c_ltgray, c_ltgray
			);
			
			draw_line_width_color(
				laserStartPoint.X, laserStartPoint.Y,
				laserEndPoint.X, laserEndPoint.Y, 1, c_red, c_red
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
			global.HighlightHandlerRef.highlightedTarget = noone;
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