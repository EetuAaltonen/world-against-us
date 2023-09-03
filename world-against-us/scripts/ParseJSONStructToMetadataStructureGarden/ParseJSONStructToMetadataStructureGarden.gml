function ParseJSONStructToMetadataStructureGarden(_jsonStruct)
{
	var parsedMetadata = undefined;
	
	if (!is_undefined(_jsonStruct))
	{
		if (is_undefined(_jsonStruct)) return parsedMetadata;
		var structureMetadataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(structureMetadataStruct) <= 0) return parsedMetadata;
		
		parsedMetadata = new MetadataStructureGarden();
		
		var toolsInventoryStruct = structureMetadataStruct[$ "tools_inventory"] ?? undefined;
		if (!is_undefined(toolsInventoryStruct))
		{
			parsedMetadata.tools_inventory = ParseJSONStructToInventory(toolsInventoryStruct);
		}
								
		var fertilizerInventoryStruct = structureMetadataStruct[$ "fertilizer_inventory"] ?? undefined;
		if (!is_undefined(fertilizerInventoryStruct))
		{
			parsedMetadata.fertilizer_inventory = ParseJSONStructToInventory(fertilizerInventoryStruct);
		}
								
		var waterInventoryStruct = structureMetadataStruct[$ "water_inventory"] ?? undefined;
		if (!is_undefined(waterInventoryStruct))
		{
			parsedMetadata.water_inventory = ParseJSONStructToInventory(waterInventoryStruct);
		}
								
		var seedInventoryStruct = structureMetadataStruct[$ "seed_inventory"] ?? undefined;
		if (!is_undefined(seedInventoryStruct))
		{
			parsedMetadata.seed_inventory = ParseJSONStructToInventory(seedInventoryStruct);
		}
								
		var outputInventoryStruct = structureMetadataStruct[$ "output_inventory"] ?? undefined;
		if (!is_undefined(outputInventoryStruct))
		{
			parsedMetadata.output_inventory = ParseJSONStructToInventory(outputInventoryStruct);
		}
	}
	
	return parsedMetadata;
}