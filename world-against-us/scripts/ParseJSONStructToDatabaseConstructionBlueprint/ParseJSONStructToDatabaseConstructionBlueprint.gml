function ParseJSONStructToDatabaseConstructionBlueprint(_jsonStruct)
{
	var parsedConstructionBlueprint = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedConstructionBlueprint;
		var constructionBlueprintStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(constructionBlueprintStruct) <= 0) return parsedConstructionBlueprint;
		
		var materials = ParseJSONStructToArray(_jsonStruct[$ "materials"] ?? undefined, ParseJSONStructToDatabaseBlueprintMateria);
		parsedConstructionBlueprint = new ConstructionBlueprint(
			materials,
			constructionBlueprintStruct[$ "output_building_name"] ?? undefined,
			constructionBlueprintStruct[$ "output_building_object"] ?? undefined
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedConstructionBlueprint;
}