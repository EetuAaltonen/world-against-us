if (muzzleFlashTimer > 0)
{
	draw_sprite_ext(
		sprMuzzleFlash, 0,
		x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y,
		image_xscale, image_yscale,
		image_angle, c_white, 1
	);
}

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
	
	if (owner.character.behavior == CHARACTER_BEHAVIOR.PLAYER)
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
		
		if (!is_undefined(primaryWeapon.metadata.left_hand_position))
		{
			var playerSpritePos = new Vector2(
				owner.x- owner.sprite_xoffset,
				owner.y - owner.sprite_yoffset
			);
			
			// LEFT ARM
			var leftHandPosition = CalculateHandPosition(primaryWeapon.metadata.left_hand_position);
			leftHandPosition.X += x;
			leftHandPosition.Y += y;
			
			var leftShoulderPosition = new Vector2(
				playerSpritePos.X + (42 * owner.image_xscale),
				playerSpritePos.Y + (28 * owner.image_yscale)
			);
			
			var leftArmPosition = new Vector2(
				leftShoulderPosition.X - (sprite_get_xoffset(sprSoldierLeftShoulder) * owner.image_xscale),
				leftShoulderPosition.Y + ((sprite_get_height(sprSoldierLeftShoulder) - sprite_get_yoffset(sprSoldierLeftShoulder)) * owner.image_yscale)
			);
			
			var leftShoulderLength = (sprite_get_height(sprSoldierLeftShoulder) - sprite_get_yoffset(sprSoldierLeftShoulder)) * abs(owner.image_xscale);
			var leftArmLength = sprite_get_width(sprSoldierLeftArm) * abs(owner.image_xscale);

			var d = point_distance(leftShoulderPosition.X, leftShoulderPosition.Y, leftHandPosition.X, leftHandPosition.Y);
			var a = (sqr(leftShoulderLength) - sqr(leftArmLength) + sqr(d)) / (2 * d);
			var h = sqrt(abs(sqr(leftShoulderLength) - sqr(a)));
			
			var p2 = new Vector2(
				leftShoulderPosition.X + a * ( leftHandPosition.X - leftShoulderPosition.X ) / d,
				leftShoulderPosition.Y + a * ( leftHandPosition.Y - leftShoulderPosition.Y ) / d
			);
			leftArmPosition = new Vector2(
				p2.X + (h * ( leftHandPosition.Y - leftShoulderPosition.Y ) / d) * -owner.image_xscale,
				p2.Y - (h * ( leftHandPosition.X - leftShoulderPosition.X ) / d) * -owner.image_xscale
			);
			
			var leftShoulderAngle = point_direction(leftShoulderPosition.X, leftShoulderPosition.Y, leftArmPosition.X, leftArmPosition.Y) + 90 + (10 * owner.image_xscale);
			var leftArmAngle = point_direction(leftArmPosition.X, leftArmPosition.Y, leftHandPosition.X, leftHandPosition.Y);
			
			// RIGHT ARM
			var rightHandPosition = CalculateHandPosition(primaryWeapon.metadata.right_hand_position);
			rightHandPosition.X += x;
			rightHandPosition.Y += y;
			
			var rightShoulderPosition = new Vector2(
				playerSpritePos.X + (15 * owner.image_xscale),
				playerSpritePos.Y + (28 * owner.image_yscale)
			);
			
			var rightArmPosition = new Vector2(
				rightShoulderPosition.X - (sprite_get_xoffset(sprSoldierRightShoulder) * owner.image_xscale),
				rightShoulderPosition.Y + ((sprite_get_height(sprSoldierRightShoulder) - sprite_get_yoffset(sprSoldierRightShoulder)) * owner.image_yscale)
			);
			
			var rightShoulderLength = (sprite_get_height(sprSoldierRightShoulder) - sprite_get_yoffset(sprSoldierRightShoulder)) * abs(owner.image_xscale);
			var rightArmLength = sprite_get_width(sprSoldierRightArm) * abs(owner.image_xscale);

			var d = point_distance(rightShoulderPosition.X, rightShoulderPosition.Y, rightHandPosition.X, rightHandPosition.Y);
			var a = (sqr(rightShoulderLength) - sqr(rightArmLength) + sqr(d)) / (2 * d);
			var h = sqrt(abs(sqr(rightShoulderLength) - sqr(a)));
			
			var p2 = new Vector2(
				rightShoulderPosition.X + a * ( rightHandPosition.X - rightShoulderPosition.X ) / d,
				rightShoulderPosition.Y + a * ( rightHandPosition.Y - rightShoulderPosition.Y ) / d
			);
			rightArmPosition = new Vector2(
				p2.X + (h * ( rightHandPosition.Y - rightShoulderPosition.Y ) / d) * -owner.image_xscale,
				p2.Y - (h * ( rightHandPosition.X - rightShoulderPosition.X ) / d) * -owner.image_xscale
			);
			
			var rightShoulderAngle = point_direction(rightShoulderPosition.X, rightShoulderPosition.Y, rightArmPosition.X, rightArmPosition.Y) + 90 + (10 * owner.image_xscale);
			var rightArmAngle = point_direction(rightArmPosition.X, rightArmPosition.Y, rightHandPosition.X, rightHandPosition.Y);
			
			draw_sprite_ext(
				sprSoldierLeftShoulder, 0,
				leftShoulderPosition.X,
				leftShoulderPosition.Y,
				owner.image_xscale, owner.image_yscale,
				leftShoulderAngle, c_white, image_alpha
			);
			
			draw_sprite_ext(
				sprSoldierLeftArm, 0,
				leftArmPosition.X,
				leftArmPosition.Y,
				image_xscale, image_yscale,
				leftArmAngle, c_white, image_alpha
			);
			
			if (isInCameraView && sprite_index != -1) draw_self();
			
			draw_sprite_ext(
				sprSoldierRightShoulder, 0,
				rightShoulderPosition.X,
				rightShoulderPosition.Y,
				owner.image_xscale, owner.image_yscale,
				rightShoulderAngle, c_white, image_alpha
			);
			draw_sprite_ext(
				sprSoldierRightArm, 0,
				rightArmPosition.X,
				rightArmPosition.Y,
				image_xscale, image_yscale,
				rightArmAngle, c_white, image_alpha
			);
			
			draw_sprite_ext(
				sprSoldierLeftHand, 0,
				leftHandPosition.X,
				leftHandPosition.Y,
				image_xscale, image_yscale,
				image_angle, c_white, image_alpha
			);
			
			draw_sprite_ext(
				sprSoldierRightHand, 0,
				rightHandPosition.X,
				rightHandPosition.Y,
				image_xscale, image_yscale,
				rightArmAngle/*Use same angle as right arm*/,
				c_white, image_alpha
			);
			
			if (global.DEBUGMODE)
			{
				draw_text(x, y - 100, string(point_distance(rightArmPosition.X, rightArmPosition.Y, rightHandPosition.X, rightHandPosition.Y) - rightArmLength));
				
				draw_circle(
					rightShoulderPosition.X,
					rightShoulderPosition.Y,
					2, false
				);
				draw_circle(
					leftShoulderPosition.X,
					leftShoulderPosition.Y,
					2, false
				);
				
				draw_circle(
					rightArmPosition.X,
					rightArmPosition.Y,
					2, false
				);
				draw_circle(
					leftArmPosition.X,
					leftArmPosition.Y,
					2, false
				);
				
				draw_circle(
					rightHandPosition.X,
					rightHandPosition.Y,
					2, false
				);
				draw_circle(
					leftHandPosition.X,
					leftHandPosition.Y,
					2, false
				);
				
				draw_circle_color(
					rightShoulderPosition.X,
					rightShoulderPosition.Y,
					rightShoulderLength, c_orange, c_orange, true
				);
				draw_circle_color(
					leftShoulderPosition.X,
					leftShoulderPosition.Y,
					leftShoulderLength, c_orange, c_orange, true
				);
				
				draw_circle_color(
					leftHandPosition.X,
					leftHandPosition.Y,
					leftArmLength,	c_blue, c_blue, true
				);
				draw_circle_color(
					rightHandPosition.X,
					rightHandPosition.Y,
					rightArmLength,	c_blue, c_blue, true
				);
				
				draw_circle_color(
					leftArmPosition.X, leftArmPosition.Y,
					2, c_green, c_green, false
				);
				
				draw_circle_color(
					rightArmPosition.X, rightArmPosition.Y,
					2, c_green, c_green, false
				);

				draw_circle_color(x - rotatedWeaponOffset.X, y - rotatedWeaponOffset.Y, 2, c_red, c_red, false);
			}
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