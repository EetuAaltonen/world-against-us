function Character(_name, _type, _race, _behavior) constructor
{
	name = _name;
	uuid = undefined;
	type = _type;
	race = _race;
	behavior = _behavior;
	
	total_hp_percent = 100;
	stamina = 100;
	body_parts = ds_map_create();
	InitBodyParts();

	is_dead = false;
	is_fast_traveling = false;
	is_robbed = false;
	
	static InitBodyParts = function()
	{
		InitCharacterBodyParts(body_parts, race);
		UpdateTotalHp();
	}
	
	static Clone = function()
	{
		// TODO: Fix clone body parts, is_dead and other statistics
		return new Character(
			name,
			type,
			race,
			behavior
		);
	}
	
	static OnDestroy = function()
	{
		DestroyDSMapAndDeleteValues(body_parts);
		body_parts = undefined;
	}
	
	static UpdateTotalHp = function()
	{
		var totalBodyPartMaxCondition = 0;
		var totalBodyPartCondition = 0;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		if (bodyPartCount > 0)
		{
			for (var i = 0; i < bodyPartCount; i++)
			{
				var bodyPart = body_parts[? bodyPartIndices[@ i]];
			
				totalBodyPartMaxCondition += bodyPart.max_condition;
				totalBodyPartCondition += bodyPart.condition;
			}
		
			total_hp_percent = floor((totalBodyPartCondition / totalBodyPartMaxCondition) * 100);
		}
	}
	
	static Update = function()
	{
		if (!is_dead)
		{
			if (total_hp_percent <= 0)
			{
				is_dead = true;
				// TODO: Disable until loot tables are implemented correctly
				//other.sprite_index = sprGraveStone;
				//other.mask_index = SPRITE_NO_MASK;
			} else {
				UpdateStats();
			}
		}
	}
	
	static UpdateStats = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static IsInvulnerableState = function()
	{
		return (is_dead || is_fast_traveling || is_robbed);
	}
	
	static RestoreState = function()
	{
		is_dead = false;
		total_hp_percent = 100;
		
		is_fast_traveling = false;
		is_robbed = false;
	}
	
	static GetBodyPartByBoundingPosition = function(_position)
	{
		var targetBodyPart = undefined;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			if (point_in_rectangle(_position.X, _position.Y,
				bodyPart.bounding_box.top_left_point.X, bodyPart.bounding_box.top_left_point.Y,
				bodyPart.bounding_box.bottom_right_point.X, bodyPart.bounding_box.bottom_right_point.Y
			))
			{
				targetBodyPart = bodyPart;
				break;
			}
		}
		
		return targetBodyPart;
	}
	
	static TakeDamage = function(_damageSource, _targetBodyPartIndex = undefined)
	{
		// TODO: Code is still just a stump
		var incomingDamage = _damageSource.bullet.metadata.base_damage;
		var targetBodyPart = body_parts[? _targetBodyPartIndex];
		
		while (incomingDamage > 0)
		{
			if (is_undefined(targetBodyPart)) break;
			
			var dealtDamage = min(targetBodyPart.condition, incomingDamage);
			targetBodyPart.TakeDamage(dealtDamage);
			incomingDamage -= dealtDamage;
			
			UpdateTotalHp();
			
			if (total_hp_percent <= 0 || incomingDamage <= 0) break;
			
			targetBodyPart = FetchLeastDamagedBodyPart();
		}
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