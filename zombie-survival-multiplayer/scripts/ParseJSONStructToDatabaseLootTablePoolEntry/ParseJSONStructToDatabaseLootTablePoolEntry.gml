function ParseJSONStructToDatabaseLootTablePoolEntry(_jsonStruct)
{
	var lootTablePoolEntry = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return lootTablePoolEntry;
			
			lootTablePoolEntry = new LootTablePoolEntry(
				_jsonStruct[$ "name"],
				_jsonStruct[$ "count"] ?? 1,
				_jsonStruct[$ "weight"] ?? 1
			);
		} catch (error)
		{
			show_message(error);
		}
	}
	return lootTablePoolEntry;
}