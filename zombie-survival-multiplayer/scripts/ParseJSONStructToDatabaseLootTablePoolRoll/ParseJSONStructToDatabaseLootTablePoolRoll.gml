function ParseJSONStructToDatabaseLootTablePoolRoll(_jsonStruct)
{
	var lootTablePoolRoll = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return lootTablePoolRoll;
			
			lootTablePoolRoll = new LootTablePoolRoll(
				_jsonStruct[$ "min"],
				_jsonStruct[$ "max"]
			);
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return lootTablePoolRoll;
}