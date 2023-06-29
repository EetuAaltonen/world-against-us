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
			name,
			uuid,
			type,
			race,
			total_hp_percent,
			stamina,
			body_parts
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
		if (!isDead)
		{
			if (total_hp_percent <= 0)
			{
				isDead = true;
				other.sprite_index = sprGraveStone;
				other.mask_index = SPRITE_NO_MASK;
			} else {
				UpdateStats();
			}
		}
	}
	
	static UpdateStats = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static TakeDamage = function(_damageSource, _targetBodyPart = undefined)
	{
		// TODO: Code is still just a stump
		var incomingDamage = _damageSource.bullet.metadata.base_damage;
		while (incomingDamage > 0)
		{
			var leastDamagedBodyPart = FetchLeastDamagedBodyPart();
			if (is_undefined(leastDamagedBodyPart)) break;
			
			var dealtDamage = min(leastDamagedBodyPart.condition, incomingDamage);
			leastDamagedBodyPart.TakeDamage(dealtDamage);
			incomingDamage -= dealtDamage;
		}
		
		UpdateTotalHp();
	}
	
	static FetchLeastDamagedBodyPart = function()
	{
		var leastDamagedBodyPart = undefined;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			if (bodyPart.condition > 0)
			{
				if (is_undefined(leastDamagedBodyPart))
				{
					leastDamagedBodyPart = bodyPart;
				} else {
					if (bodyPart.condition > leastDamagedBodyPart.condition)
					{
						leastDamagedBodyPart = bodyPart;
					}
				}
			}
		}
		return leastDamagedBodyPart;
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