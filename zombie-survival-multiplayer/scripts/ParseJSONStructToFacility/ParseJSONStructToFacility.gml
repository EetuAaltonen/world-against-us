function ParseJSONStructToFacility(_jsonStruct)
{
	var facility = undefined;
	if (_jsonStruct)
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return facility;
	
			var facilityId = _jsonStruct[$ "facility_id"];
			var type = _jsonStruct[$ "type"];
			var metadata = ParseMetadataFacility(_jsonStruct[$ "metadata"] ?? undefined, type);
	
			facility = new Facility(
				facilityId,
				undefined,
				type,
				metadata
			);
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return facility;
}