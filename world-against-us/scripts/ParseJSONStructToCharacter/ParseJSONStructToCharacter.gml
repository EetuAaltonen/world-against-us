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
						characterStruct[$ "behavior"] ?? undefined
					);
					
					// VARYING METADATA
					if (!is_undefined(characterStruct[$ "stamina"] ?? undefined)) variable_struct_set(parsedCharacter, "stamina", characterStruct[$ "stamina"]);
					if (!is_undefined(characterStruct[$ "is_dead"] ?? undefined)) variable_struct_set(parsedCharacter, "is_dead", characterStruct[$ "is_dead"]);
					if (!is_undefined(characterStruct[$ "fullness"] ?? undefined)) variable_struct_set(parsedCharacter, "fullness", characterStruct[$ "fullness"]);
					if (!is_undefined(characterStruct[$ "hydration"] ?? undefined)) variable_struct_set(parsedCharacter, "hydration", characterStruct[$ "hydration"]);
					if (!is_undefined(characterStruct[$ "energy"] ?? undefined)) variable_struct_set(parsedCharacter, "energy", characterStruct[$ "energy"]);
					
					if (!is_undefined(characterStruct[$ "backpack"] ?? undefined))
					{
						var parsedBackpack = ParseJSONStructToItem(characterStruct[$ "backpack"]);
						if (!is_undefined(parsedBackpack))
						{
							parsedCharacter.backpack_slot.AddItem(parsedBackpack, undefined, false, true);
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