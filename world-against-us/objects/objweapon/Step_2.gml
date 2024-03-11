// CHECK GUI STATE
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (owner != noone)
{
	// POSITION
	x = owner.x;
	y = owner.y;
	
	var mouseWorldPosition = MouseWorldPosition();
	
	if (!is_undefined(primaryWeapon))
	{
		// WEAPON OFFSET
		var weaponOffset = primaryWeapon.metadata.weapon_offset.Clone();
		weaponOffset.Y = 0;
		rotatedWeaponOffset = weaponOffset.Rotate(image_angle);
		x += rotatedWeaponOffset.X;
		y += primaryWeapon.metadata.weapon_offset.Y + rotatedWeaponOffset.Y;
		
		 if (!initWeapon) {
			if (owner.character.behavior == CHARACTER_BEHAVIOR.PLAYER)
			{
				// AIM WITH WEAPON
				var aimButton = mb_right;
				if (mouse_check_button(aimButton))
				{
					if (!is_undefined(primaryWeapon))
					{
						isAiming = true;
					}
				} else if (mouse_check_button_released(aimButton))
				{
					isAiming = false;
				}
			}

			// CALCULATE BARREL LOCATION
			CalculateBarrelPos();
			
			// CALCULATE BARREL LOCATION
			CalculateChamberPos();
			
			if (owner.character.behavior == CHARACTER_BEHAVIOR.PLAYER)
			{
				// CHECK GUI STATE
				if (global.GUIStateHandlerRef.IsGUIStateClosed())
				{
					var angleCenterDistanceToBarrel = point_distance(
						x - rotatedWeaponOffset.X,
						y - rotatedWeaponOffset.Y,
						x + rotatedWeaponBarrelPos.X,
						y + rotatedWeaponBarrelPos.Y
					);
					var angleCenterDistanceToMouse = point_distance(
						x - rotatedWeaponOffset.X,
						y - rotatedWeaponOffset.Y,
						mouseWorldPosition.X,
						mouseWorldPosition.Y
					);
					
					if (angleCenterDistanceToMouse > angleCenterDistanceToBarrel)
					{
						image_angle = point_direction(x, y, mouseWorldPosition.X, mouseWorldPosition.Y);
					} else {
						image_angle = point_direction(x - rotatedWeaponOffset.X, y - rotatedWeaponOffset.Y, mouseWorldPosition.X, mouseWorldPosition.Y);
					}
					
					// SHOOTING DELAY AND ANIMATION
					fireDelay = max(-1, --fireDelay);
					muzzleFlashTimer = max(0, --muzzleFlashTimer);
					kickbackAnimation = max(0, --kickbackAnimation);
					
					PlayerWeaponFunctions();
				}
			}
		}
	}

	// ADD RECOIL
	x -= lengthdir_x(kickbackAnimation, image_angle);
	y -= lengthdir_y(kickbackAnimation, image_angle);
	
	// IMAGE INDEX
	if (!is_undefined(primaryWeapon))
	{
		image_index = is_undefined(primaryWeapon.metadata.magazine);
	}
	
	// DEPTH
	// TODO: Rotate character and the gun to point -z-axis while pointing gun "upward"
	//depth = (spriteDirection.image_z_scale == 1) ? owner.depth - 1 : owner.depth + 1;
	depth = owner.depth - 1;

	// FLIP HORIZONTALLY
	image_yscale = /*spriteDirection.image_x_scale * */spriteScale * sign(owner.image_xscale);
}
