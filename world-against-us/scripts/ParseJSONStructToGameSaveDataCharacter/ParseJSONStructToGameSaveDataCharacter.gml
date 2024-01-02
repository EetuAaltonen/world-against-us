function ParseJSONStructToGameSaveDataCharacter(_jsonStruct)
{
	var parsedCharacter = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedCharacter;
		var characterStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(characterStruct) <= 0) return characterStruct;
		
		var parsedBackpack = ParseJSONStructToItem(characterStruct[$ "backpack"]);
		parsedCharacter = new GameSaveDataCharacter(
			characterStruct[$ "name"] ?? EMPTY_STRING,
			parsedBackpack
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedCharacter;
}