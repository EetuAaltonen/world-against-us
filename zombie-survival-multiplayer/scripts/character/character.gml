function Character(_name, _type) constructor
{
	name = _name;
	uuid = undefined;
	type = _type;
	
	totalHpPercent = 0;
	stamina = 100;
	
	maxFullness = 100;
	fullness = maxFullness;
	hungerBaseRate = 0.0025;
	hungerRate = hungerBaseRate;
	
	maxHydration = 100;
	hydration = maxHydration;
	thirstBaseRate = 0.00015;
	thirstRate = thirstBaseRate;
	
	maxEnergy = 100;
	energy = maxEnergy;
	fatigueBaseRate = 0.0001;
	fatigueRate = fatigueBaseRate;
	
	bodyParts = ds_map_create();
	InitBodyParts();
	
	isDead = false;
	
	static InitBodyParts = function()
	{
		ds_map_clear(bodyParts);
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Head, new CharacterBodyPart("Head"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Chest, new CharacterBodyPart("Chest"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightArm, new CharacterBodyPart("Right Arm"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftArm, new CharacterBodyPart("Left Arm"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Stomach, new CharacterBodyPart("Stomach"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightLeg, new CharacterBodyPart("Right Leg"));
		ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftLeg, new CharacterBodyPart("Left Leg"));
		
		UpdateTotalHp();
	}
	
	static Clone = function()
	{
		var cloneCharacter = new Character(name, type);
		return cloneCharacter;
	}
	
	static UpdateStats = function()
	{
		if (totalHpPercent <= 0)
		{
			isDead = true;
		} else {
			fullness = clamp(fullness - (hungerRate / room_speed), 0, maxFullness);
			hydration = clamp(hydration - (thirstRate / room_speed), 0, maxHydration);
			energy = clamp(energy - (fatigueRate / room_speed), 0, maxEnergy);
		}
	}
	
	static UpdateTotalHp = function()
	{
		var totalBodyPartMaxCondition = 0;
		var totalBodyPartCondition = 0;
		var bodyPartIndices = ds_map_keys_to_array(bodyParts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = bodyParts[? bodyPartIndices[@ i]];
			
			totalBodyPartMaxCondition += bodyPart.maxCondition;
			totalBodyPartCondition += bodyPart.condition;
		}
		
		totalHpPercent = floor((totalBodyPartCondition / totalBodyPartMaxCondition) * 100);
	}
	
	static TakeDamage = function(_damage, _targetBodyPart = undefined)
	{
		// TODO: Code is still just a stump
		show_message(string(_item));
		
		UpdateTotalHp();
	}
	
	static UseMedicine = function(_item, _targetBodyPartIndex = undefined)
	{
		if (totalHpPercent < 100)
		{
			if (!is_undefined(_targetBodyPartIndex))
			{
				var bodyPart = bodyParts[? _targetBodyPartIndex];
				if (bodyPart.condition < bodyPart.maxCondition)
				{
					var healAmount = min(_item.metadata.healing_left, (bodyPart.maxCondition - bodyPart.condition));
						
					bodyPart.Heal(healAmount);
					_item.metadata.healing_left -= healAmount;
					if (_item.metadata.healing_left <= 0)
					{
						_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
					}
					
					// MESSAGE LOG
					AddMessageLog(string("{0} healed to {1} / {2}", bodyPart.name, bodyPart.condition, bodyPart.maxCondition));
				} else {
					// MESSAGE LOG
					AddMessageLog(string("{0} is already fully healed", bodyPart.name));
				}
			} else {
				while (true)
				{
					var mostDamagedBodyPart = FetchMostDamagedBodyPart();
					if (is_undefined(mostDamagedBodyPart)) break;
					if (_item.metadata.healing_left <= 0)
					{
						_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
						break;
					}
					
					var healAmount = min(_item.metadata.healing_left, (mostDamagedBodyPart.maxCondition - mostDamagedBodyPart.condition));
					mostDamagedBodyPart.condition += healAmount;
					_item.metadata.healing_left -= healAmount;
					
					// MESSAGE LOG
					AddMessageLog(string("{0} healed to {1} / {2}", mostDamagedBodyPart.name, mostDamagedBodyPart.condition, mostDamagedBodyPart.maxCondition));
				}
			}
		} else {
			// MESSAGE LOG
			AddMessageLog("You are already fully healed");	
		}
		
		UpdateTotalHp();
	}
	
	static FetchMostDamagedBodyPart = function()
	{
		var mostDamagedBodyPart = undefined;
		var bodyPartIndices = ds_map_keys_to_array(bodyParts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = bodyParts[? bodyPartIndices[@ i]];
			if (bodyPart.condition < bodyPart.maxCondition)
			{
				if (is_undefined(mostDamagedBodyPart))
				{
					mostDamagedBodyPart = bodyPart;
				} else {
					if (bodyPart.condition < mostDamagedBodyPart.condition)
					{
						mostDamagedBodyPart = bodyPart;
					}
				}
			}
		}
		return mostDamagedBodyPart;
	}
	
	static EatItem = function(_item)
	{
		if (ceil(fullness) < maxFullness)
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
		if (ceil(hydration) < maxHydration)
		{
			// TODO: Code is still just a stump
			show_message(string(_item));
		} else {
			// MESSAGE LOG
			AddMessageLog("You feel already well hydrated");
		}
	}
}