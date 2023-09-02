function ParseJSONStructToDatabaseConstructionBlueprint(_jsonStruct)
{
	var blueprint = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return blueprint;
			var outputBuildingName = _jsonStruct[$ "output_building_name"] ?? undefined;
			var outputBuildingObjectName = _jsonStruct[$ "output_building_object"] ?? undefined;
			var materials = ParseJSONStructToArray(_jsonStruct[$ "materials"] ?? undefined, ParseJSONStructToDatabaseBlueprintMateria);
			blueprint = new ConstructionBlueprint(
				materials,
				outputBuildingName,
				outputBuildingObjectName
			);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	return blueprint;
}