function WorldStateHandler() constructor
{
	world_states = ds_map_create();
	
	date_time = new WorldStateDateTime();
	date_time.day = 1;
	date_time.hours = 8;
	
	weather = WEATHER_CONDITION.CLEAR;
	
	sky_light_max_level = 1;
	sky_light_level = sky_light_max_level;
	sky_darkness_max_level = 0.98;
	sky_darkness_dusk_hours = 19; // When darkness starts
	sky_darkness_early_night_hours = 22; // When blind darkness starts
	sky_darkness_early_morning_hours = 4; // When blind darkness ends
	sky_darkness_dawn_hours = 7; // When darkness ends
	sky_darkness_last_update_minutes = -1;
	
	InitWorldStates();
	
	static OnDestroy = function()
	{
		ClearDSMapAndDeleteValues(world_states);
		ds_map_destroy(world_states);
	}
	
	static InitWorldStates = function()
	{
		ClearDSMapAndDeleteValues(world_states);
		world_states[? WORLD_STATE_UNLOCK_WALKIE_TALKIE] = false;
	}
	
	/// @function		Update()
	/// @description	Called on every game loop
	/// @return {bool}
	static Update = function()
	{
		date_time.Update();
		// UPDATE SKY LIGHT LEVEL
		if (sky_darkness_last_update_minutes != date_time.minutes)
		{
			sky_darkness_last_update_minutes = date_time.minutes;
			var fxLayerId = layer_get_id(LAYER_EFFECT_LIGHT);
			if (layer_exists(fxLayerId))
			{
				if (date_time.hours >= sky_darkness_dusk_hours || date_time.hours < sky_darkness_dawn_hours)
				{
					if (!layer_fx_is_enabled(fxLayerId)) { layer_enable_fx(fxLayerId, true); }
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
									sky_light_level = sky_light_max_level - RoundToTwoDecimals(sky_darkness_max_level - (sky_darkness_max_level * (minutesTillNight / totalDuskMinutes)));
								} else if (date_time.hours >= sky_darkness_early_morning_hours && date_time.hours < sky_darkness_dawn_hours)
								{
									var totalDawnMinutes = (sky_darkness_dawn_hours - sky_darkness_early_morning_hours) * 60;
									var minutesTillDay = ((sky_darkness_dawn_hours - date_time.hours) * 60) - date_time.minutes;
									sky_light_level = sky_light_max_level - RoundToTwoDecimals(sky_darkness_max_level * (minutesTillDay / totalDawnMinutes));
								} else {
									// SET SKY LIGHT LEVEL TO BLIND DARK AT DARKEST HOURS
									sky_light_level = sky_light_max_level - sky_darkness_max_level;
								}
								fxParams.g_TintCol = [sky_light_level, sky_light_level, sky_light_level, 1];
								fx_set_parameters(fxEffect, fxParams);
							}
						}
					}
				} else {
					if (layer_fx_is_enabled(fxLayerId)) { layer_enable_fx(fxLayerId, false); }
					if (sky_light_level < sky_light_max_level) { sky_light_level = sky_light_max_level; }
				}
			}
		}
	}
	
	static SetWorldTime = function(_networkWorldStateSync)
	{
		date_time.year = _networkWorldStateSync.date_time.year;
		date_time.month = _networkWorldStateSync.date_time.month;
		date_time.day = _networkWorldStateSync.date_time.day;
		date_time.hours = _networkWorldStateSync.date_time.hours;
		date_time.minutes = _networkWorldStateSync.date_time.minutes;
		date_time.seconds = _networkWorldStateSync.date_time.seconds;
		date_time.milliseconds = _networkWorldStateSync.date_time.milliseconds;
	}
	
	/// @function		SetWeather(_weather)
	/// @description	Set a new weather condition
	///					and updates visual effects
	/// @param	{number} weather
	/// @return {bool}
	static SetWeather = function(_weather)
	{
		var isWeatherSet = false;
		if (weather != _weather)
		{
			// CLEAR CURRENT WEATHER
			var currentFxLayerName = string(
				"{0}{1}",
				LAYER_EFFECT_PREFIX,
				array_get(WEATHER_TEXT, weather)
			);
			var currentFxLayerId = layer_get_id(currentFxLayerName);
			if (layer_exists(currentFxLayerId))
			{
				if (layer_fx_is_enabled(currentFxLayerId))
				{
					layer_enable_fx(currentFxLayerId, false);
				}
			}
			// SET NEW WEATHER
			weather = _weather;
			UpdateWeatherEffect();
			isWeatherSet = true;
		} else {
			// NO CHANGES
			isWeatherSet = true;
		}
		return isWeatherSet;
	}
	
	static SetWorldStateProperty = function(_worldStateIndex, _new_value)
	{
		world_states[? _worldStateIndex] = _new_value;
	}
	
	static UpdateWeatherEffect = function()
	{
		if (weather > WEATHER_CONDITION.CLEAR)
		{
			var newFxLayerName = string("{0}{1}", LAYER_EFFECT_PREFIX, array_get(WEATHER_TEXT, weather));
			var newFxLayerId = layer_get_id(newFxLayerName);
			if (layer_exists(newFxLayerId))
			{
				if (!layer_fx_is_enabled(newFxLayerId)) { layer_enable_fx(newFxLayerId, true); }
			}
		}
	}
	
	static GetWeatherText = function()
	{
		return string("Weather - {0}", array_get(WEATHER_TEXT, weather));
	}
}