function ParseJSONStructToDatabaseLootTablePool(_jsonStruct)
{
	var parsedLootTablePool = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedLootTablePool;
		var lootTablePoolStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(lootTablePoolStruct) <= 0) return parsedLootTablePool;
			
		var poolRolls = ParseJSONStructToDatabaseLootTablePoolRoll(lootTablePoolStruct[$ "rolls"] ?? undefined);
		var poolEntries = ParseJSONStructToArray(lootTablePoolStruct[$ "entries"] ?? undefined, ParseJSONStructToDatabaseLootTablePoolEntry);
			
		parsedLootTablePool = new LootTablePool(
			lootTablePoolStruct[$ "roll_chance"] ?? undefined,
			poolRolls,
			poolEntries
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedLootTablePool;
}