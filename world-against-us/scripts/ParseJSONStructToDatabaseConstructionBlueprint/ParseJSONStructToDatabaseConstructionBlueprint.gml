function ParseJSONStructToDatabaseConstructionBlueprint(_jsonStruct)
{
	var blueprint = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return blueprint;
			var outputBuildingName = _jsonStruct[$ "output_building_name"];
			var outputBuildingObjectName = _jsonStruct[$ "output_building_object"];
			var materials = ParseJSONStructToArray(_jsonStruct[$ "materials"], ParseJSONStructToDatabaseBlueprintMateria);
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