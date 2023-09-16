function ParseJSONStructToDatabaseLootTablePoolEntry(_jsonStruct)
{
	var parsedLootTablePoolEntry = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedLootTablePoolEntry;
		var lootTablePoolEntyStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(lootTablePoolEntyStruct) <= 0) return parsedLootTablePoolEntry;
			
		parsedLootTablePoolEntry = new LootTablePoolEntry(
			lootTablePoolEntyStruct[$ "name"] ?? undefined,
			lootTablePoolEntyStruct[$ "count"] ?? 0,
			lootTablePoolEntyStruct[$ "weight"] ?? 0
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedLootTablePoolEntry;
}