function CharacterPlayer(_name, _type, _race) : Character(_name, _type, _race) constructor
{
	max_fullness = 100;
	fullness = max_fullness;
	hunger_base_rate = 0.0025;
	hunger_rate = hunger_base_rate;
	
	max_hydration = 100;
	hydration = max_hydration;
	thirst_base_rate = 0.00015;
	thirst_rate = thirst_base_rate;
	
	max_energy = 100;
	energy = max_energy;
	fatigue_base_rate = 0.0001;
	fatigue_rate = fatigue_base_rate;
	
	static UpdateStats = function()
	{
		if (total_hp_percent <= 0)
		{
			isDead = true;
		} else {
			fullness = clamp(fullness - (hunger_rate / game_get_speed(gamespeed_fps)), 0, max_fullness);
			hydration = clamp(hydration - (thirst_rate / game_get_speed(gamespeed_fps)), 0, max_hydration);
			energy = clamp(energy - (fatigue_rate / game_get_speed(gamespeed_fps)), 0, max_energy);
		}
	}
	
	static UseMedicine = function(_item, _targetBodyPartIndex = undefined)
	{
		if (total_hp_percent < 100)
		{
			if (!is_undefined(_targetBodyPartIndex))
			{
				var bodyPart = body_parts[? _targetBodyPartIndex];
				if (bodyPart.condition < bodyPart.max_condition)
				{
					var healAmount = min(_item.metadata.healing_left, (bodyPart.max_condition - bodyPart.condition));
					bodyPart.Heal(healAmount);
					_item.metadata.healing_left -= healAmount;
					
					// MESSAGE LOG
					AddMessageLog(string("{0} healed to {1} / {2}", bodyPart.name, bodyPart.condition, bodyPart.max_condition));
				} else {
					// MESSAGE LOG
					AddMessageLog(string("{0} is already fully healed", bodyPart.name));
				}
			} else {
				while (true)
				{
					var mostDamagedBodyPart = FetchMostDamagedBodyPart();
					if (is_undefined(mostDamagedBodyPart) || _item.metadata.healing_left <= 0) break;
					
					var healAmount = min(_item.metadata.healing_left, (mostDamagedBodyPart.max_condition - mostDamagedBodyPart.condition));
					mostDamagedBodyPart.condition += healAmount;
					_item.metadata.healing_left -= healAmount;
					
					// MESSAGE LOG
					AddMessageLog(string("{0} healed to {1} / {2}", mostDamagedBodyPart.name, mostDamagedBodyPart.condition, mostDamagedBodyPart.max_condition));
				}
			}
		} else {
			// MESSAGE LOG
			AddMessageLog("You are already fully healed");	
		}
		
		UpdateTotalHp();
	}
	
	static EatItem = function(_item)
	{
		if (ceil(fullness) < max_fullness)
		{
			// TODO: Code is still just a stump
			show_message(string(_item));
		} else {
			// MESSAGE LOG
			AddMessageLog("You don't feel hungry");	
		}
	}
	
	static DrinkItem = function(_item)
	{
		if (ceil(hydration) < max_hydration)
		{
			// TODO: Code is still just a stump
			show_message(string(_item));
		} else {
			// MESSAGE LOG
			AddMessageLog("You feel already well hydrated");
		}
	}
}