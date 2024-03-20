function WindowDebugMonitorGraph(_elementId, _relativePosition, _size, _backgroundColor, _samples, _graphTitle, _graphLegendTitle, _sampleInterval, _maxSampleValueGetterFunc, _yAxisTitle, _graphLineColor, _drawValuePointColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	samples = _samples;
	graphTitle = _graphTitle;
	graphLegendTitle = _graphLegendTitle;
	sampleInterval = _sampleInterval;
	maxSampleValueGetterFunc = _maxSampleValueGetterFunc;
	yAxisTitle = _yAxisTitle;
	graphLineColor = _graphLineColor;
	drawValuePointColor = _drawValuePointColor;
	
	static DrawContent = function()
	{
		var framePadding = 10;
		var valueLineStepping = 1 / 5;
		var maxSampleValue = maxSampleValueGetterFunc();
		var graphMaxValueRaw = maxSampleValue + (maxSampleValue * 0.1);
		var graphMaxValue = ceil(graphMaxValueRaw / 5) * 5;
		
		draw_set_font(font_console);
		draw_set_color(#dbdbdb);
		
		// DRAW GRAPH BACKGROUND
		var graphBackgroundScale = ScaleSpriteToFitSizeStretch(sprDebugMonitroGraphWide, size);
		draw_sprite_ext(
			sprDebugMonitroGraphWide, 0,
			position.X, position.Y,
			graphBackgroundScale.X,
			graphBackgroundScale.Y,
			0, c_white, 1
		);
		
		// DRAW GRAPH TITLE
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text(
			position.X + (size.w * 0.5),
			position.Y - 40,
			graphTitle
		);
		
		// DRAW GRAPH LEGEND ICON
		var graphLegendsYPos = position.Y - 20;
		draw_line_width_color(
			position.X + (size.w * 0.5) - 30,
			graphLegendsYPos,
			position.X + (size.w * 0.5) - 5,
			graphLegendsYPos,
			3, graphLineColor, graphLineColor
		);
		// DRAW GRAPH LEGEND TITLE
		draw_set_halign(fa_left);
		draw_set_valign(fa_center);
		draw_text(
			position.X + (size.w * 0.5) + 5,
			graphLegendsYPos,
			graphLegendTitle
		);
		
		draw_set_halign(fa_right);
		draw_set_valign(fa_middle);
		
		// DRAW TOP LINE VALUE
		draw_text(
			position.X,
			position.Y + framePadding,
			string("{0}", graphMaxValue)
		);
		// DRAW GRAPH VALUE LINES
		for (var i = 0; i < 4; i++)
		{
			var lineYPos = position.Y + (size.h - framePadding - ((size.h - (framePadding * 2)) * (valueLineStepping * (i + 1))));
			// DRAW LINE VALUE
			draw_text(
				position.X,
				lineYPos,
				string("{0}", floor(graphMaxValue * (valueLineStepping * (i + 1))))
			);
		}
		
		// DRAW GRAPH AXIS TITLES
		draw_set_halign(fa_left);
		draw_set_valign(fa_bottom);
		// Y-AXIS
		draw_text(
			position.X,
			position.Y,
			yAxisTitle
		);
		
		if (is_array(samples))
		{
			// SAMPLE COUNT
			var sampleCount = array_length(samples);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
			var sampleCountText = string(
				"Sample count: {0}",
				sampleCount
			);
			draw_text(
				position.X,
				position.Y + size.h,
				sampleCountText
			);
			
			if (!is_undefined(sampleInterval))
			{
				// SAMPLE INTERVAL
				draw_set_halign(fa_center);
				var sampleIntervalText = string(
					"Sample interval: {0}ms",
					sampleInterval
				);
				draw_text(
					position.X + (size.w * 0.5),
					position.Y + size.h,
					sampleIntervalText
				);
			
				// SAMPLING PERIOD
				draw_set_halign(fa_right);
				var firstSample = array_first(samples);
				var samplingStartTime = (!is_undefined(firstSample)) ? (firstSample.time_stamp ?? current_time) : 0;
				var lastSample = array_last(samples);
				var samplingEndTime = (!is_undefined(lastSample)) ? (lastSample.time_stamp ?? current_time) : 0;
				var samplingTime = (samplingEndTime - samplingStartTime);
				
				var totalSampleTimeMinutes = floor(samplingTime / 60000);
				var totalSampleTimeSeconds = floor((samplingTime % 60000) / 1000);
				var totalSampleMinutesFormatText = (totalSampleTimeMinutes < 10) ? string("0{0}", totalSampleTimeMinutes) : totalSampleTimeMinutes;
				var totalSampleSecondsFormatText = (totalSampleTimeSeconds < 10) ? string("0{0}", totalSampleTimeSeconds) : totalSampleTimeSeconds;
				var samplingPeriodText = string(
					"Sampling period: {0}min {1}s",
					totalSampleMinutesFormatText,
					totalSampleSecondsFormatText
				);
				draw_text(
					position.X + size.w,
					position.Y + size.h,
					samplingPeriodText
				);
			}
			
			var graphPointXPadding = framePadding + 10;
			var graphPointMargin = ((size.w - (graphPointXPadding * 2)) / (sampleCount - 1));
			for (var i = 0; i < sampleCount; i++)
			{
				var sample = samples[@ i];
				var sampleNormalized = (sample.value / graphMaxValue);
				var samplePointX = position.X + graphPointXPadding + (graphPointMargin * i);
				var samplePointY = position.Y + (size.h - framePadding) - ((size.h - (framePadding * 2)) * sampleNormalized);
				var nextIndex = (i + 1);
				var nextSampleValue = undefined;
				if (nextIndex < sampleCount)
				{
					var nextSample = samples[@ nextIndex];
					if (!is_undefined(nextSample))
					{
						nextSampleValue = nextSample.value ?? 0;
					}
				}
				// DRAW SAMPLE LINE
				if (!is_undefined(nextSampleValue))
				{
					var nextSampleNormalized = (nextSampleValue / graphMaxValue);
					draw_line_width_color(
						samplePointX, samplePointY,
						position.X + graphPointXPadding + (graphPointMargin * (i + 1)),
						position.Y + (size.h - framePadding) - ((size.h - (framePadding * 2)) * nextSampleNormalized),
						2, graphLineColor, graphLineColor
					);
				}
				
				// DRAW SAMPLE POINT
				if (!is_undefined(drawValuePointColor))
				{
					draw_circle_color(
						samplePointX,
						samplePointY,
						2, drawValuePointColor, drawValuePointColor, false
					);
				}
				
				// DRAW LAST SAMPLE VALUE
				if (i == (sampleCount - 1))
				{
					draw_set_halign(fa_left);
					draw_set_valign(fa_middle);
					draw_set_color(graphLineColor)
					draw_text(
						position.X + size.w - framePadding,
						samplePointY,
						string(sample.value)
					);
				}
			}
		}
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}