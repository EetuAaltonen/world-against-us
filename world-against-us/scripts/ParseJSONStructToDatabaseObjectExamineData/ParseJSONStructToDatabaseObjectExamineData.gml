function ParseJSONStructToDatabaseObjectExamine(_jsonStruct)
{
	var parsedExamineData = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (is_undefined(_jsonStruct)) return parsedExamineData;
			var objectExamineStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
			if (variable_struct_names_count(objectExamineStruct) <= 0) return parsedExamineData;
			
			var parsedObjectName = objectExamineStruct[$ "object_name"] ?? UNDEFINED_OBJECT_NAME;
			if (parsedObjectName != UNDEFINED_OBJECT_NAME)
			{
				var objectIndex = asset_get_index(parsedObjectName);
				if (objectIndex > -1)
				{
					var parsedObjectSprite = GetSpriteByName(objectExamineStruct[$ "icon"] ?? undefined);
					parsedExamineData = new ObjectExamine(
						parsedObjectName,
						objectExamineStruct[$ "display_name"] ?? EMPTY_STRING,
						parsedObjectSprite,
						objectExamineStruct[$ "description"] ?? EMPTY_STRING
					);
				} else {
					throw (string("Unable to find object index for {0} in object data parsing", parsedObjectName));
				}
			} else {
				throw (string("Trying to parse object examine data with 'undefined' object name", parsedObjectName));
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	return parsedExamineData;
}