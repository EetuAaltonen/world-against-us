// HUD BACKGROUND
draw_sprite_ext(sprGUIBg, 0, 0, global.GUIH - hudHeight, global.GUIW, hudHeight, 0, c_black, 0.9);
	
var hudVerticalCenter = (global.GUIH - (hudHeight * 0.5));
draw_set_color(c_white);
draw_set_halign(fa_center);
	
// HEALTH
var iconPos = new Vector2(60, hudVerticalCenter - 10);
draw_sprite_ext(
	sprHeart, 0,
	iconPos.X, iconPos.Y,
	heartScale, heartScale,
	0, c_white, image_alpha
);
	
if (instance_exists(global.ObjPlayer))
{
	if (!is_undefined(global.ObjPlayer.character))
	{
		// HEART PULSE
		var linePointCount = ds_list_size(pulseLinePoints);
		var pulseLineStep = TimerRatePerMinute(beatRate) / linePointCount;
		for (var i = 0; i < (linePointCount - 1); i++)
		{
			var linePoint = ds_list_find_value(pulseLinePoints, i);
			var nextLinePoint = ds_list_find_value(pulseLinePoints, i + 1);
			draw_line_width_colour(
				linePoint.X, linePoint.Y,
				nextLinePoint.X, nextLinePoint.Y,
				2, colPulseLine, colPulseLine
			);
		
			var pulseTimerMin = (pulseLineStep * i);
			var pulseTimerMax = (pulseLineStep * (i + 1));
			var pulseLinePercent = ((pulseTimer - pulseTimerMin) / (pulseTimerMax - pulseTimerMin));
			if (pulseLinePercent > 0 && pulseLinePercent < 1)
			{
				var xPointerPos = linePoint.X;
				var yPointerPos = linePoint.Y;
			
				xPointerPos += (pulseLinePercent * (nextLinePoint.X - linePoint.X));
				yPointerPos += (pulseLinePercent * (nextLinePoint.Y - linePoint.Y));
			
				draw_circle_color(xPointerPos, yPointerPos, (pulseIndicatorSize * 0.5), colPulsePointer, colPulsePointer, false);
			}
		}
		// HEALTH
		draw_text(iconPos.X, hudVerticalCenter + 10, string(global.ObjPlayer.character.totalHpPercent) + "%");
	
		// FULLNESS
		var iconPos = new Vector2(160, hudVerticalCenter - 15);
		draw_sprite_ext(
			sprHunger, 0,
			iconPos.X, iconPos.Y,
			scaleHUDIcons, scaleHUDIcons,
			0, c_white, image_alpha
		);
		draw_text(iconPos.X, hudVerticalCenter + 10, string("{0}%", ceil(global.ObjPlayer.character.fullness)));
	
		// HYDRATION
		var iconPos = new Vector2(230, hudVerticalCenter - 15);
		draw_sprite_ext(
			sprHydration, 0,
			iconPos.X, iconPos.Y,
			scaleHUDIcons, scaleHUDIcons,
			0, c_white, image_alpha
		);
		draw_text(iconPos.X, hudVerticalCenter + 10, string("{0}%", ceil(global.ObjPlayer.character.hydration)));
			
		// ENERGY
		var iconPos = new Vector2(300, hudVerticalCenter - 15);
		draw_sprite_ext(
			sprEnergy, 0,
			iconPos.X, iconPos.Y,
			scaleHUDIcons, scaleHUDIcons,
			0, c_white, image_alpha
		);
		draw_text(iconPos.X, hudVerticalCenter + 10, string("{0}%", ceil(global.ObjPlayer.character.energy)));
	
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}
	
// WEAPON AMMO
if (global.GUIStateHandler.IsGUIStateClosed())
{
	if (instance_exists(global.ObjPlayer))
	{
		var weapon = global.ObjPlayer.weapon;

		if (!is_undefined(weapon.primaryWeapon) && !weapon.initWeapon)
		{
			if (array_length(weapon.bulletAnimations) > 0)
			{
				// DRAW MAGAZINE BACKGROUND
				var bulletMargin = 10;
				var bgWidth = 100;
				var bgHeight = (bulletMargin * weapon.primaryWeapon.metadata.magazine_size) + (bulletMargin * 4);
				var xPos = global.GUIW - bgWidth;
				var yPos = global.GUIH - bgHeight;
		
				draw_sprite_ext(sprGUIBg, 0, xPos, yPos, bgWidth, bgHeight, 0, c_black, 0.8);
		
				// DRAW BULLETS
				var bulletSprite = GetBulletSpriteByCaliber(weapon.primaryWeapon.metadata.caliber);
				var bulletScale = ScaleSpriteToFitSize(bulletSprite, new Size(undefined, bulletMargin));
				var animationEndPos = 100;
				xPos = global.GUIW - (bgWidth * 0.5);
				yPos = global.GUIH - (bulletMargin * 2);
		
				for (var i = 0; i < weapon.primaryWeapon.metadata.magazine_size; i++)
				{
					if (i < weapon.primaryWeapon.metadata.bullet_count)
					{
						draw_sprite_ext(
							bulletSprite, 0,
							xPos, yPos - (bulletMargin * i),
							-bulletScale, bulletScale, 0, c_white, 1
						);
					} else {
						var step = weapon.bulletAnimations[i];
						var animationEndPos = 100;
						if (step >= 0 && step < 1)
						{
							draw_sprite_ext(
								bulletSprite, 0,
								xPos + (animationEndPos * step), yPos - (bulletMargin * i) - (animationEndPos * step),
								-bulletScale, bulletScale, -180 * step, c_white, 1
							);
							weapon.bulletAnimations[i] += weapon.bulletAnimationStep;
						}
					}
			
				}
			}
		}
	}
}