// CHECK GUI STATE
if (!IsGUIStateClosed()) return;


x = objPlayer.x;
y = objPlayer.y + 32;

image_angle = point_direction(x, y, mouse_x, mouse_y);

fireDelay = max(-1, fireDelay - 1);
recoilAnimation = max(0, recoilAnimation - 1);

if (primaryWeapon != noone)
{
	if (initWeapon)
	{
		initWeapon = false;
		
		sprite_index = primaryWeapon.icon;
		fireDelay = 0;
		recoilAnimation = 0;
		bulletAnimations = array_create(primaryWeapon.metadata.magazine_size, 1);
	}
	
	if (primaryWeapon.metadata.bullet_count > 0)
	{
		if (mouse_check_button(mb_left) && fireDelay <= 0)
		{
			var xOrigin = sprite_get_xoffset(sprite_index);
			var yOrigin = sprite_get_yoffset(sprite_index);
			
			var barrelXPos = primaryWeapon.metadata.barrel_pos.X - xOrigin;
			var barrelYPos = ((primaryWeapon.metadata.barrel_pos.Y - yOrigin) * image_yscale);
			
			var radAngle = degtorad(-image_angle);
			var cs = cos(radAngle);
			var sn = sin(radAngle);
			var bulletXPos = barrelXPos * cs - barrelYPos * sn; 
			var bulletYPos = barrelXPos * sn + barrelYPos * cs;
			
			var bullet = instance_create_layer(x + bulletXPos, y + bulletYPos, "Projectiles", objProjectile);
			var bulletRecoil = random_range(-primaryWeapon.metadata.recoil, primaryWeapon.metadata.recoil);
			
			bullet.sprite_index = GetBulletSpriteFromCaliber(primaryWeapon.metadata.caliber);
			bullet.direction = image_angle + bulletRecoil;
			bullet.image_angle = bullet.direction;
			bullet.image_xscale = 0.2;
			bullet.image_yscale = bullet.image_xscale;
			bullet.range = MetersToPixels(primaryWeapon.metadata.range);
	
			recoilAnimation = 4;
			bulletAnimations[primaryWeapon.metadata.bullet_count - 1] = 0;
			primaryWeapon.metadata.bullet_count--;
			fireDelay = TimerRatePerMinute(primaryWeapon.metadata.fire_rate);
		}
	}

	if (keyboard_check_released(ord("R")))
	{
		primaryWeapon.metadata.bullet_count = primaryWeapon.metadata.magazine_size;
		bulletAnimations = array_create(primaryWeapon.metadata.magazine_size, 1);
	}
}

x = x - lengthdir_x(recoilAnimation, image_angle);
y = y - lengthdir_y(recoilAnimation, image_angle);

// Flip weapon while holding in certain angle
image_yscale = (image_angle > 90 && image_angle < 270) ? -1 : 1;
