function CharacterHuman(_name, _type, _race, _behavior) : Character(_name, _type, _race, _behavior) constructor
{
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
	
	backpack_slot = new Inventory(string("{0}_Inventory", _name), INVENTORY_TYPE.BackpackSlot, new InventorySize(3, 4), new InventoryFilter([], ["Backpack"], []));
	
	static ToJSONStruct = function()
	{
		
		var scaledStamina = ScaleFloatValueToInt(stamina);
		
		// TODO: Fix body part ToJSONStruct logic
		//var formatBodyParts = (!is_undefined(body_parts)) ? body_parts[@ 0].ToJSONStruct() : undefined;
		
		var scaledFullness = ScaleFloatValueToInt(fullness);
		var scaledHydration = ScaleFloatValueToInt(hydration);
		var scaledEnergy = ScaleFloatValueToInt(energy);
		
		var backpack = backpack_slot.GetItemByIndex(0);
		var formatBackpack = (!is_undefined(backpack)) ? backpack.ToJSONStruct() : undefined;
		
		return {
			name: name,
			uuid: uuid,
			type: type,
			race: race,
			stamina: scaledStamina,
			
			body_parts: undefined,
			is_dead: is_dead,
			
			fullness: scaledFullness,
			hydration: scaledHydration,
			energy: scaledEnergy,
			
			backpack: formatBackpack
		}
	}
	
	static OnDestroy = function()
	{
		// OVERRIDE FROM PARENT
		backpack_slot.OnDestroy();
		backpack_slot = undefined;
		DestroyDSMapAndDeleteValues(body_parts);
		body_parts = undefined;
	}
	
	static UpdateStats = function()
	{
		fullness = clamp(fullness - (hunger_rate / game_get_speed(gamespeed_fps)), 0, max_fullness);
		hydration = clamp(hydration - (thirst_rate / game_get_speed(gamespeed_fps)), 0, max_hydration);
		energy = clamp(energy - (fatigue_rate / game_get_speed(gamespeed_fps)), 0, max_energy);
	}
	
	static GetBackpackSlotItem = function()
	{
		return backpack_slot.GetItemByIndex(0);
	}
	
	static GetBackpackInventory = function()
	{
		var backpackInventory = undefined;
		var backpackItem = GetBackpackSlotItem();
		if (!is_undefined(backpackItem))
		{
			if (!is_undefined(backpackItem.metadata))
			{
				backpackInventory = backpackItem.metadata.inventory;	
			}
		}
		return backpackInventory;
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