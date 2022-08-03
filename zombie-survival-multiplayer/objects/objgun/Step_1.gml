x = objPlayer.x;
y = objPlayer.y + 32;

image_angle = point_direction(x, y, mouse_x, mouse_y);

fireDelay = max(-1, fireDelay - 1);
recoil = max(-1, recoil - 1);
if (bulletCount > 0)
{
	if (mouse_check_button(mb_left) && fireDelay < 0)
	{
		var bullet = instance_create_layer(x, y, "Projectiles", obj9mmBullet);
		var bulletRecoil = random_range(-1, 1);
		bullet.direction = image_angle + bulletRecoil;
		bullet.image_angle = bullet.direction;
		bullet.image_xscale = 0.3;
		bullet.image_yscale = bullet.image_xscale;
	
		recoil = 4;
		bulletAnimations[bulletCount - 1] = 0;
		bulletCount -= 1;
		fireDelay = TimerRatePerMinute(fireRate);
	}
}

if (keyboard_check_released(ord("R")))
{
	bulletCount = magazineSize;
	bulletAnimations = array_create(magazineSize, 1);
}

x = x - lengthdir_x(recoil, image_angle);
y = y - lengthdir_y(recoil, image_angle);

// Flip weapon while holding in certain angle
image_yscale = (image_angle > 90 && image_angle < 270) ? -1 : 1;
