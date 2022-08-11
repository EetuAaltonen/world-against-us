// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

if (primaryWeapon != noone && !initWeapon)
{
	if (array_length(bulletAnimations) > 0)
	{
		// DRAW MAGAZINE BACKGROUND
		var bulletMargin = 10;
		var bgWidth = 100;
		var bgHeight = (bulletMargin * primaryWeapon.metadata.magazine_size) + (bulletMargin * 4);
		var xPos = global.GUIW - bgWidth;
		var yPos = global.GUIH - bgHeight;
		
		draw_sprite_ext(sprGUIBg, 0, xPos, yPos, bgWidth, bgHeight, 0, c_white, 0.8);
		
		// DRAW BULLETS
		var bulletSprite = GetBulletSpriteFromCaliber(primaryWeapon.metadata.caliber);
		var bulletScale = ScaleSpriteToFitSize(bulletSprite, undefined, bulletMargin);
		var animationEndPos = 100;
		xPos = global.GUIW - (bgWidth * 0.5);
		yPos = global.GUIH - (bulletMargin * 2);
		
		for (var i = 0; i < primaryWeapon.metadata.magazine_size; i++)
		{
			if (i < primaryWeapon.metadata.bullet_count)
			{
				draw_sprite_ext(
					bulletSprite, 0,
					xPos, yPos - (bulletMargin * i),
					-bulletScale, bulletScale, 0, c_white, 1
				);
			} else {
				var step = bulletAnimations[i];
				var animationEndPos = 100;
				if (step >= 0 && step < 1)
				{
					draw_sprite_ext(
						bulletSprite, 0,
						xPos + (animationEndPos * step), yPos - (bulletMargin * i) - (animationEndPos * step),
						-bulletScale, bulletScale, -180 * step, c_white, 1
					);
					bulletAnimations[i] += bulletAnimationStep;
				}
			}
			
		}
	}
}