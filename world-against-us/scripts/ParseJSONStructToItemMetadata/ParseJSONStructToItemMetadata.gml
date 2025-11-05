function ParseJSONStructToItemMetadata(_jsonStruct, _itemData)
{
	// POPULATE METADATA WITH DATABASE VALUES
	// THEN MODIFY IT WITH VARYING METADATA FROM JSON DATA
	var parsedMetadata = _itemData.metadata
	try
	{
		if (is_undefined(_jsonStruct)) return parsedMetadata;
		var metadataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(metadataStruct) <= 0) return parsedMetadata;
		if (is_undefined(_itemData.category)) return parsedMetadata;
		
		switch (_itemData.category)
		{
			case "Weapon":
			{
				if (_itemData.type == "Melee")
				{
					// NO VARYING METADATA
				} else if (_itemData.type == "Shotgun")
				{
					parsedMetadata.shells = ParseJSONStructToArray(metadataStruct[$ "shells"] ?? undefined, ParseJSONStructToItem);
				} else if (_itemData.type == "Flamethrower")
				{
					parsedMetadata.fuel_tank = ParseJSONStructToItem(metadataStruct[$ "fuel_tank"] ?? parsedMetadata.fuel_tank);
				} else {
					parsedMetadata.magazine = ParseJSONStructToItem(metadataStruct[$ "magazine"] ?? parsedMetadata.magazine);
				}
			} break;
			case "Magazine":
			{
				parsedMetadata.bullets = metadataStruct[$ "bullets"] ?? parsedMetadata.bullets;
			} break;
			case "Fuel Ammo":
			{
				parsedMetadata.fuel_level = metadataStruct[$ "fuel_level"] ?? parsedMetadata.fuel_level;
			} break;
			case "Bullet":
			{
				// NO VARYING METADATA
			} break;
			case "Medicine":
			{
				parsedMetadata.healing_left = metadataStruct[$ "healing_left"] ?? parsedMetadata.healing_left;
			} break;
			case "Fuel":
			{
				parsedMetadata.fuel_left = metadataStruct[$ "fuel_left"] ?? parsedMetadata.fuel_left;
			} break;
			case "Consumable":
			{
				if (_itemData.type == "Food")
				{
					parsedMetadata = new MetadataItemFood(
						metadataStruct[$ "nutrition"] ?? undefined
					);
				} else if (_itemData.type == "Liquid")
				{
					parsedMetadata = new MetadataItemLiquid(
						metadataStruct[$ "hydration"] ?? undefined
					);
				}
			} break;
			case "Backpack":
			{
				var parsedInventory = ParseJSONStructToInventory(metadataStruct[$ "inventory"]);
				if (!is_undefined(parsedInventory))
				{
					parsedMetadata.Initialize(parsedInventory);
				}
			} break;
		}
	} catch (error) {
		show_debug_message(error);
		show_message(error);
	}
	return parsedMetadata;
}