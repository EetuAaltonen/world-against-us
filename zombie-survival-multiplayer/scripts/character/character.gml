function Character(_name, _type, _race) constructor
{
	name = _name;
	uuid = undefined;
	type = _type;
	race = _race;
	
	total_hp_percent = 0;
	stamina = 100;
	body_parts = undefined;
	InitBodyParts();
	
	isDead = false;
	
	static InitBodyParts = function()
	{
		body_parts = InitCharacterBodyParts(race);
		if (!is_undefined(body_parts))
		{
			UpdateTotalHp();
		}
	}
	
	static Clone = function()
	{
		return new Character(
			name, type
		);
	}
	
	static UpdateTotalHp = function()
	{
		var totalBodyPartMaxCondition = 0;
		var totalBodyPartCondition = 0;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			
			totalBodyPartMaxCondition += bodyPart.max_condition;
			totalBodyPartCondition += bodyPart.condition;
		}
		
		total_hp_percent = floor((totalBodyPartCondition / totalBodyPartMaxCondition) * 100);
	}
	
	static Update = function()
	{
		UpdateStats();
	}
	
	static UpdateStats = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static TakeDamage = function(_damage_source, _targetBodyPart = undefined)
	{
		// TODO: Code is still just a stump
		show_message(string(_damage_source));
		
		UpdateTotalHp();
	}
	
	static FetchMostDamagedBodyPart = function()
	{
		var mostDamagedBodyPart = undefined;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			if (bodyPart.condition < bodyPart.max_condition)
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
}