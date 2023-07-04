// CHECK GUI STATE
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (owner != noone)
{
	// POSITION
	x = owner.x;
	y = owner.y + weaponYOffset;
	depth = owner.depth - 1;
	
	if (!is_undefined(primaryWeapon))
	{
		 if (!initWeapon) {
			if (owner.character.type == CHARACTER_TYPE.PLAYER)
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
			
			if (owner.character.type == CHARACTER_TYPE.PLAYER)
			{
				// CHECK GUI STATE
				if (global.GUIStateHandlerRef.IsGUIStateClosed())
				{
					var mouseWorldPosition = MouseWorldPosition();
					image_angle = point_direction(x, y, mouseWorldPosition.X, mouseWorldPosition.Y);
					// SHOOTING DELAY AND ANIMATION
					fireDelay = max(-1, --fireDelay);
					muzzleFlashTimer = max(0, --muzzleFlashTimer);
					recoilAnimation = max(0, --recoilAnimation);
					
					PlayerWeaponFunctions();
				}
			}
		}
	}

	// ADD RECOIL
	x -= lengthdir_x(recoilAnimation, image_angle);
	y -= lengthdir_y(recoilAnimation, image_angle);
	
	// IMAGE INDEX
	if (!is_undefined(primaryWeapon))
	{
		image_index = is_undefined(primaryWeapon.metadata.magazine);
	}

	// FLIP HORIZONTALLY
	image_yscale = (image_angle > 90 && image_angle < 270) ? -spriteScale : spriteScale;
}
