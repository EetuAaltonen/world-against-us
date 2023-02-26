function ParseJSONStructToDatabaseLootTablePool(_jsonStruct)
{
	var lootTablePool = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return lootTablePool;
			
			var poolRolls = ParseJSONStructToDatabaseLootTablePoolRoll(_jsonStruct[$ "rolls"]);
			var poolEntries = ParseJSONStructToArray(_jsonStruct[$ "entries"], ParseJSONStructToDatabaseLootTablePoolEntry);
			
			lootTablePool = new LootTablePool(
				_jsonStruct[$ "roll_chance"],
				poolRolls,
				poolEntries
			);
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return lootTablePool;
}