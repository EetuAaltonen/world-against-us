function ParseJSONStructToMetadataStructureConstructionSite(_jsonStruct)
{
	var parsedMetadata = undefined;
	
	if (!is_undefined(_jsonStruct))
	{
		if (is_undefined(_jsonStruct)) return parsedMetadata;
		var structureMetadataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(structureMetadataStruct) <= 0) return parsedMetadata;
		
		parsedMetadata = new MetadataStructureConstructionSite();
		
		var materialSlotInventories = structureMetadataStruct[$ "material_slots"] ?? undefined;
		if (!is_undefined(materialSlotInventories))
		{
			var materialSlotCount = array_length(materialSlotInventories);
			for (var i = 0; i < materialSlotCount; i++)
			{
				var materialSlotStruct = materialSlotInventories[@ i];
				if (!is_undefined(materialSlotStruct))
				{
					var slotStructInventoryId = materialSlotStruct[$ "inventory_id"] ?? undefined;
					if (!is_undefined(slotStructInventoryId))
					{
						var metadataMaterialSlotCount = array_length(parsedMetadata.material_slots);
						for (var j = 0; j < metadataMaterialSlotCount; j++)
						{
							var metadataMaterialSlot = parsedMetadata.material_slots[@ j];
							if (metadataMaterialSlot.inventory_id == slotStructInventoryId)
							{
								var parsedMaterialSlotInventory = ParseJSONStructToInventory(materialSlotStruct);
								if (!is_undefined(parsedMaterialSlotInventory))
								{
									metadataMaterialSlot.items = parsedMaterialSlotInventory.items;
								}
							}
						}
					}
				}
			}
		}
	}
	
	return parsedMetadata;
}