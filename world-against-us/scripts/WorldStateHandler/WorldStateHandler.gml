function WorldStateHandler() constructor
{
	world_states = undefined;
	
	date_time = new WorldStateDateTime();
	date_time.day = 1;
	date_time.hours = 8;
	
	weather = 0;
	sky_darkness_level = 0;
	sky_darkness_max_level = 0.98;
	sky_darkness_dusk_hours = 19; // When darkness starts
	sky_darkness_early_night_hours = 22; // When blind darkness starts
	sky_darkness_early_morning_hours = 4; // When blind darkness ends
	sky_darkness_dawn_hours = 7; // When darkness ends
	
	InitWorldStates();
	
	static InitWorldStates = function()
	{
		world_states = ds_map_create();
		world_states[? WORLD_STATE_UNLOCK_WALKIE_TALKIE] = false;
	}
	
	static SetWorldState = function(_worldStateIndex, _new_value)
	{
		world_states[? _worldStateIndex] = _new_value;
	}
	
	static Update = function()
	{
		date_time.Update();
		
		// UPDATE SKY LIGHT LEVEL
		var fxLayerId = layer_get_id("EffectLight");
		if (layer_exists(fxLayerId))
		{
			if (date_time.hours >= sky_darkness_dusk_hours || date_time.hours < sky_darkness_dawn_hours)
			{
				if (!layer_get_visible("EffectLight")) { layer_set_visible("EffectLight", true); }
				if (!layer_fx_is_enabled("EffectLight")) { layer_enable_fx("EffectLight", true); }
				var fxEffect = layer_get_fx(fxLayerId);
				if (fxEffect != -1)
				{
					var fxParams = fx_get_parameters(fxEffect);
					if (fxParams != -1)
					{
						if (!is_undefined(fxParams[$ "g_TintCol"]))
						{
							if (date_time.hours >= sky_darkness_dusk_hours && date_time.hours < sky_darkness_early_night_hours)
							{
								var totalDuskMinutes = (sky_darkness_early_night_hours - sky_darkness_dusk_hours) * 60;
								var minutesTillNight = ((sky_darkness_early_night_hours - date_time.hours) * 60) - date_time.minutes;
								sky_darkness_level = 1 - RoundToTwoDecimals(sky_darkness_max_level - (sky_darkness_max_level * (minutesTillNight / totalDuskMinutes)));
							} else if (date_time.hours < sky_darkness_dawn_hours && date_time.hours >= sky_darkness_early_morning_hours)
							{
								var totalDawnMinutes = (sky_darkness_dawn_hours - sky_darkness_early_morning_hours) * 60;
								var minutesTillDay = ((sky_darkness_dawn_hours - date_time.hours) * 60) - date_time.minutes;
								sky_darkness_level = 1 - RoundToTwoDecimals(sky_darkness_max_level * (minutesTillDay / totalDawnMinutes));
							}
							fxParams.g_TintCol = [sky_darkness_level,sky_darkness_level,sky_darkness_level,1];
							fx_set_parameters(fxEffect, fxParams);
						}
					}
				}
			} else {
				if (layer_get_visible("EffectLight")) { layer_set_visible("EffectLight", false); }
				if (layer_fx_is_enabled("EffectLight")) { layer_enable_fx("EffectLight", false); }
				if (sky_darkness_level > 0) { sky_darkness_level = 0; }
			}
		}
	}
}