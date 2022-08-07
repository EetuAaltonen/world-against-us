if (global.ShowHUD)
{
	// HUD BACKGROUND
	draw_set_alpha(alphaHUGBg);
	GUIDrawBox(0, global.GUIH - hudHeight, global.GUIW, hudHeight, colHUDBg);
	draw_set_alpha(1);
	
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
	draw_text(iconPos.X, hudVerticalCenter + 10, string(100) + "%");
	
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
	
	// HUNGER
	var iconPos = new Vector2(160, hudVerticalCenter - 15);
	draw_sprite_ext(
		sprHunger, 0,
		iconPos.X, iconPos.Y,
		scaleHUDIcons, scaleHUDIcons,
		0, c_white, image_alpha
	);
	draw_text(iconPos.X, hudVerticalCenter + 10, string(100) + "%");
	
	// HYDRATION
	var iconPos = new Vector2(230, hudVerticalCenter - 15);
	draw_sprite_ext(
		sprHydration, 0,
		iconPos.X, iconPos.Y,
		scaleHUDIcons, scaleHUDIcons,
		0, c_white, image_alpha
	);
	draw_text(iconPos.X, hudVerticalCenter + 10, string(100) + "%");
	
	draw_set_color(c_black);
	draw_set_halign(fa_left);
}
