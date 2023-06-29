function HUDElementHealth(_position) : HUDElement(_position) constructor
{
	heartBaseScale = 0.5;
	heartScale = heartBaseScale;
	heartPulseScale = 0.7;

	baseBeatRate = 70; // per minute
	beatRate = baseBeatRate; 
	pulseDelay = 10; // in frames
	pulseTimer = TimerRatePerMinute(beatRate);
	pulseLinePoints = [
		new Vector2(120, global.GUIH - 50),
		new Vector2(70, global.GUIH - 50),
		new Vector2(60, global.GUIH - 30),
		new Vector2(50, global.GUIH - 60),
		new Vector2(40, global.GUIH - 40),
		new Vector2(10, global.GUIH - 40)
	];
	pulseIndicatorSize = 8;
	
	colPulseLine = make_colour_rgb(53, 138, 0);
	colPulsePointer = make_colour_rgb(55, 255, 0);
	
	static Update = function()
	{
		if (pulseTimer > 0 && pulseTimer <= pulseDelay)
		{
			heartScale = heartPulseScale;
		} else if (pulseTimer <= 0)
		{
			heartScale = heartBaseScale;
			pulseTimer = TimerRatePerMinute(beatRate);
		}
		pulseTimer--;
	}
	
	static SetBeatRate = function(_newBeatRate)
	{
		beatRate = _newBeatRate;
	}
	
	static ResetBeatRate = function()
	{
		beatRate = baseBeatRate;
	}
	
	static Draw = function()
	{
		if (instance_exists(global.ObjPlayer))
		{
			if (!is_undefined(global.ObjPlayer.character))
			{
				var heartIconPos = new Vector2(position.X, position.Y - 10);
				draw_sprite_ext(
					sprHeart, 0,
					heartIconPos.X, heartIconPos.Y,
					heartScale, heartScale,
					0, c_white, 1
				);

				// HEART PULSE
				var linePointCount = array_length(pulseLinePoints);
				var pulseLineStep = TimerRatePerMinute(beatRate) / linePointCount;
				for (var i = 0; i < (linePointCount - 1); i++)
				{
					var linePoint = pulseLinePoints[@ i];
					var nextLinePoint = pulseLinePoints[@ (i+1)];
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
			
						draw_circle_color(
							xPointerPos, yPointerPos,
							(pulseIndicatorSize * 0.5),
							colPulsePointer, colPulsePointer, false
						);
					}
				}
				
				draw_set_font(font_small);
				draw_set_color(c_white);
				draw_set_halign(fa_center);
				
				// HEALTH VALUE
				draw_text(position.X, position.Y + 10, string(global.ObjPlayer.character.total_hp_percent) + "%");
				
				// RESET DRAW PROPERTIES
				ResetDrawProperties();
			}
		}
	}
}