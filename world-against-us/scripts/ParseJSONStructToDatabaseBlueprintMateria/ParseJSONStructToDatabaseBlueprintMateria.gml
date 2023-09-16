function ParseJSONStructToDatabaseBlueprintMateria(_jsonStruct)
{
	var parsedBlueprintMaterial = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedBlueprintMaterial;
		var blueprintMaterialStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(blueprintMaterialStruct) <= 0) return parsedBlueprintMaterial;
			
		parsedBlueprintMaterial = new BlueprintMaterial(
			blueprintMaterialStruct[$ "name"] ?? undefined,
			blueprintMaterialStruct[$ "quantity"] ?? 1
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedBlueprintMaterial;
}