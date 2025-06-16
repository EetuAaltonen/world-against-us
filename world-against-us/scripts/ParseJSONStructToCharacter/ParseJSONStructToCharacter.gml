function ParseJSONStructToCharacter(_jsonStruct)
{
	var parsedCharacter = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedCharacter;
		var characterStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(characterStruct) <= 0) return parsedCharacter;
		
		var characterTypeStruct = characterStruct[$ "type"] ?? undefined;
		if (!is_undefined(characterTypeStruct))
		{
			switch (characterTypeStruct)
			{
				case CHARACTER_TYPE.Human:
				{
					parsedCharacter = new CharacterHuman(
						characterStruct[$ "name"] ?? undefined,
						characterStruct[$ "type"] ?? undefined,
						characterStruct[$ "race"] ?? undefined,
						undefined, // SET BEHAVIOR TO INSTANCE BY OBJECT TYPE
						undefined // SET COLLIDER TO INSTANCE BY OBJECT TYPE 
					);
					
					// VARYING METADATA
					if (!is_undefined(characterStruct[$ "stamina"] ?? undefined)) parsedCharacter.stamina = ScaleIntValueToFloat(characterStruct[$ "stamina"]);
					
					if (!is_undefined(characterStruct[$ "fullness"] ?? undefined)) parsedCharacter.fullness = ScaleIntValueToFloat(characterStruct[$ "fullness"]);
					if (!is_undefined(characterStruct[$ "hydration"] ?? undefined)) parsedCharacter.hydration = ScaleIntValueToFloat(characterStruct[$ "hydration"]);
					if (!is_undefined(characterStruct[$ "energy"] ?? undefined)) parsedCharacter.energy = ScaleIntValueToFloat(characterStruct[$ "energy"]);
					
					var characterGear = characterStruct[$ "gear"] ?? undefined;
					if (!is_undefined(characterGear))
					{
						if (!is_undefined(characterGear[$ "helmet"] ?? undefined))
						{
							var parsedHelmetItem = ParseJSONStructToItem(characterGear[$ "helmet"] ?? undefined);
							if (!is_undefined(parsedHelmetItem)) parsedCharacter.gear.helmet.AddItem(parsedHelmetItem, undefined, false);
						}
						if (!is_undefined(characterGear[$ "body_armor"] ?? undefined))
						{
							var parsedBodyArmorItem = ParseJSONStructToItem(characterGear[$ "body_armor"] ?? undefined);
							if (!is_undefined(parsedBodyArmorItem)) parsedCharacter.gear.body_armor.AddItem(parsedBodyArmorItem, undefined, false);
						}
						if (!is_undefined(characterGear[$ "backpack"] ?? undefined))
						{
							var parsedBackpackItem = ParseJSONStructToItem(characterGear[$ "backpack"] ?? undefined);
							if (!is_undefined(parsedBackpackItem)) parsedCharacter.gear.backpack.AddItem(parsedBackpackItem, undefined, false);
						}
						if (!is_undefined(characterGear[$ "primary_weapon"] ?? undefined))
						{
							var parsedPrimaryWeaponItem = ParseJSONStructToItem(characterGear[$ "primary_weapon"] ?? undefined);
							if (!is_undefined(parsedPrimaryWeaponItem)) parsedCharacter.gear.primary_weapon.AddItem(parsedPrimaryWeaponItem, undefined, false);
						}
						if (!is_undefined(characterGear[$ "secondary_weapon"] ?? undefined))
						{
							var parsedSecondaryWeaponItem = ParseJSONStructToItem(characterGear[$ "secondary_weapon"] ?? undefined);
							if (!is_undefined(parsedSecondaryWeaponItem)) parsedCharacter.gear.secondary_weapon.AddItem(parsedSecondaryWeaponItem, undefined, false);
						}
					}
				} break;
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	
	return parsedCharacter;
}