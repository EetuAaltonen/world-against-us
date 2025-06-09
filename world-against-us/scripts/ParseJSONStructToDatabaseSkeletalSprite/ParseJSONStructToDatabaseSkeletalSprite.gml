function ParseJSONStructToDatabaseSkeletalSprite(_jsonStruct)
{
	var parsedSkeletalSpriteData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedSkeletalSpriteData;
		var skeletalSpriteDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(skeletalSpriteDataStruct) <= 0) return parsedSkeletalSpriteData;
	
		var animations = ds_map_create();
		ParseJSONStructToMap(animations, skeletalSpriteDataStruct[$ "animations"] ?? undefined, "name", ParseJSONStructToDatabaseSkeletalSpriteAnimation);
		parsedSkeletalSpriteData = new SkeletalSpriteData(
			skeletalSpriteDataStruct[$ "sprite_name"] ?? undefined,
			animations
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedSkeletalSpriteData;
}