// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

if (primaryWeapon != noone && !initWeapon)
{
	if (array_length(bulletAnimations) > 0)
	{
		var bgWidth = 30;
		var vOffset = 10;
		var xPos = global.GUIW - bgWidth;
		var yPos = global.GUIH - vOffset;
		var bulletScale = 0.25;

		draw_set_alpha(0.6);
		draw_rectangle_color(
			xPos - bgWidth,
			yPos - (vOffset * 4) - ((vOffset - 1) * primaryWeapon.metadata.magazine_size),
			global.GUIW, global.GUIH,
			c_black, c_black,
			c_black, c_black, false
		);

		draw_set_alpha(1);
		for (var i = 0; i < primaryWeapon.metadata.magazine_size; i++)
		{
			if (i < primaryWeapon.metadata.bullet_count)
			{
				draw_sprite_ext(
					spr9mmBullet, 0,
					xPos, yPos - (vOffset * i),
					-bulletScale, bulletScale, 0, c_white, 1
				);
			} else {
				var step = bulletAnimations[i];
				var animationEndPos = 100;
				if (step >= 0 && step < 1)
				{
					draw_sprite_ext(
						spr9mmBullet, 0,
						xPos + (animationEndPos * step), yPos - (vOffset * i) - (animationEndPos * step),
						-bulletScale, bulletScale, -180 * step, c_white, 1
					);
					bulletAnimations[i] += bulletAnimationStep;
				}
			}
		}
	}
}