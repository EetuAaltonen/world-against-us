function ParseJSONStructToDatabaseLootTablePoolRoll(_jsonStruct)
{
	var parsedLootTablePoolRoll = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedLootTablePoolRoll;
		var lootTablePoolRollStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(lootTablePoolRollStruct) <= 0) return parsedLootTablePoolRoll;
			
		parsedLootTablePoolRoll = new LootTablePoolRoll(
			lootTablePoolRollStruct[$ "min"] ?? 0,
			lootTablePoolRollStruct[$ "max"] ?? 0
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedLootTablePoolRoll;
}