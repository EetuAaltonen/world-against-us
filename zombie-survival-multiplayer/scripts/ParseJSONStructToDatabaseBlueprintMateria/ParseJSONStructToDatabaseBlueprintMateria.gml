function ParseJSONStructToDatabaseBlueprintMateria(_jsonStruct)
{
	var blueprintMaterial = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return blueprintMaterial;
			
			blueprintMaterial = new BlueprintMaterial(
				_jsonStruct[$ "name"],
				_jsonStruct[$ "quantity"]
			);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	return blueprintMaterial;
}