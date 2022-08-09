// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

// POSITION
x = objPlayer.x;
y = objPlayer.y + gunYOffset;

image_angle = point_direction(x, y, mouse_x, mouse_y);

// SHOOTING DELAY AND ANIMATION
fireDelay = max(-1, fireDelay - 1);
recoilAnimation = max(0, recoilAnimation - 1);

if (primaryWeapon != noone)
{
	// FETCH WEAPON DATA
	if (initWeapon)
	{
		initWeapon = false;
		
		sprite_index = primaryWeapon.icon;
		fireDelay = 0;
		recoilAnimation = 0;
		bulletAnimations = array_create(primaryWeapon.metadata.magazine_size, 1);
	}
	
	// CALCULATE BARREL LOCATION
	var xOrigin = sprite_get_xoffset(sprite_index);
	var yOrigin = sprite_get_yoffset(sprite_index);
	var barrelPos = new Vector2(
		primaryWeapon.metadata.barrel_pos.X - xOrigin,
		((primaryWeapon.metadata.barrel_pos.Y - yOrigin) * image_yscale)
	);
	rotatedWeaponBarrelPos = RotateVector(barrelPos, image_angle);
	
	if (primaryWeapon.metadata.bullet_count > 0)
	{
		// SHOOT
		if (mouse_check_button(mb_left) && fireDelay <= 0)
		{
			var bullet = instance_create_layer(x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y, "Projectiles", objProjectile);
			var aimRecoilReduction = (isAiming) ? 0.3 : 1;
			var bulletRecoil = random_range(-primaryWeapon.metadata.recoil, primaryWeapon.metadata.recoil) * aimRecoilReduction;
			var barrelAngle = point_direction(x + rotatedWeaponBarrelPos.X, y +rotatedWeaponBarrelPos.Y, mouse_x, mouse_y);
			
			bullet.sprite_index = GetBulletSpriteFromCaliber(primaryWeapon.metadata.caliber);
			bullet.direction = barrelAngle + bulletRecoil;
			bullet.image_angle = bullet.direction;
			bullet.image_xscale = 0.2;
			bullet.image_yscale = bullet.image_xscale;
			bullet.range = MetersToPixels(primaryWeapon.metadata.range);
	
			recoilAnimation = 8;
			bulletAnimations[primaryWeapon.metadata.bullet_count - 1] = 0;
			primaryWeapon.metadata.bullet_count--;
			fireDelay = TimerRatePerMinute(primaryWeapon.metadata.fire_rate);
		}
	}

	// RELOAD
	if (keyboard_check_released(ord("R")))
	{
		primaryWeapon.metadata.bullet_count = primaryWeapon.metadata.magazine_size;
		bulletAnimations = array_create(primaryWeapon.metadata.magazine_size, 1);
	}
}

// ADD RECOIL
x -= lengthdir_x(recoilAnimation, image_angle);
y -= lengthdir_y(recoilAnimation, image_angle);

// FLIP HORIZONTALLY
image_yscale = (image_angle > 90 && image_angle < 270) ? -1 : 1;
