function CharacterHuman(_name, _type, _race, _behavior, _colliderRef) : Character(_name, _type, _race, _behavior) constructor
{
	collider_ref = _colliderRef;
	
	// STATS
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
	
	// MOBILITY
	// TODO: Add variables for walking and running
	// and make this adjustable
	max_speed = 5;
	
	// SENSES
	vision_radius = MetersToPixels(20);
	
	// COMBAT
	close_range_radius = MetersToPixels(2);
	
	// GEAR SLOTS
	gear = new GearSlots(_name);
	
	// ACTION
	action_handler = new CharacterHumanActionHandler();
	
	// POSTURE
	default_posture = CHARACTER_POSTURE_HUMAN.STAND;
	posture = default_posture;
	
	static ToJSONStruct = function()
	{
		var scaledStamina = ScaleFloatValueToInt(stamina);
		var scaledFullness = ScaleFloatValueToInt(fullness);
		var scaledHydration = ScaleFloatValueToInt(hydration);
		var scaledEnergy = ScaleFloatValueToInt(energy);
		
		var formatGear = (!is_undefined(gear)) ? gear.ToJSONStruct() : undefined;
		
		return {
			name: name,
			uuid: uuid,
			type: type,
			race: race,
			stamina: scaledStamina,
			
			fullness: scaledFullness,
			hydration: scaledHydration,
			energy: scaledEnergy,
			
			gear: formatGear
		}
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.gear);
		_struct.gear = undefined;
		ReleaseVariableFromMemory(_struct.action_handler);
		_struct.action_handler = undefined;
	}
	
	static Update = function()
	{
		if (!is_undefined(collider_ref))
		{
			if (!is_undefined(collider_ref.collision_body))
			{
				if (collider_ref.collision_body.state == COLLISION_BODY_STATE.ALIVE)
				{
					UpdateStats();
					action_handler.Update();
				} else if (collider_ref.collision_body.state == COLLISION_BODY_STATE.ON_DEAD)
				{
					// TODO: Fix OnDead logic
					//OnDead();
				}
			}
		}
	}
	
	static UpdateStats = function()
	{
		if (behavior == CHARACTER_BEHAVIOR.PLAYER)
		{
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
					
					// LOG NOTIFICATION
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							undefined,
							string("{0} healed to {1} / {2}", bodyPart.name, bodyPart.condition, bodyPart.max_condition),
							undefined,
							NOTIFICATION_TYPE.Log
						)
					);
				} else {
					// LOG NOTIFICATION
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							undefined,
							string("{0} is already fully healed", bodyPart.name),
							undefined,
							NOTIFICATION_TYPE.Log
						)
					);
				}
			} else {
				while (true)
				{
					var mostDamagedBodyPart = FetchMostDamagedBodyPart();
					if (is_undefined(mostDamagedBodyPart) || _item.metadata.healing_left <= 0) break;
					
					var healAmount = min(_item.metadata.healing_left, (mostDamagedBodyPart.max_condition - mostDamagedBodyPart.condition));
					mostDamagedBodyPart.condition += healAmount;
					_item.metadata.healing_left -= healAmount;
					
					// LOG NOTIFICATION
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							undefined,
							string("{0} healed to {1} / {2}", mostDamagedBodyPart.name, mostDamagedBodyPart.condition, mostDamagedBodyPart.max_condition),
							undefined,
							NOTIFICATION_TYPE.Log
						)
					);
				}
			}
		} else {
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"You are already fully healed",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
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
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"You don't feel hungry",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	}
	
	static DrinkItem = function(_item)
	{
		if (ceil(hydration) < max_hydration)
		{
			// TODO: Code is still just a stump
			show_message(string(_item));
		} else {
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"You feel already well hydrated",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	}
}