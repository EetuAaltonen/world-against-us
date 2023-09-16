function ParseJSONStructToFacility(_jsonStruct)
{
	var parsedFacility = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedFacility;
		var facilityStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(facilityStruct) <= 0) return parsedFacility;
		
		var type = facilityStruct[$ "type"] ?? undefined;
		var metadata = ParseMetadataFacility(facilityStruct[$ "metadata"] ?? undefined, type);
	
		parsedFacility = new Facility(
			facilityStruct[$ "facility_id"] ?? undefined,
			undefined,
			type,
			metadata
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedFacility;
}