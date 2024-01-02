/// @description Custom RoomStartEvent
if (!is_undefined(structureId))
{
	var structureMetadata = new MetadataStructureGarden();
	structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.Garden, structureMetadata);
	
	// TODO: Fix this code
	// CHECK IF STRUCTURE HAS ROOM SAVE RECORD
	/*var structureSaveData = global.GameSaveHandlerRef.GetStructureInteractableContentById(structure.structure_id);
	if (!is_undefined(structureSaveData))
	{
		if (!is_undefined(structureSaveData.metadata))
		{
			var saveDataToolsInventory = structureSaveData.metadata.tools_inventory;
			if (!is_undefined(saveDataToolsInventory))
			{
				structure.metadata.tools_inventory.AddMultipleItems(saveDataToolsInventory.items);
			}
		
			var saveDataFertilizerInventory = structureSaveData.metadata.fertilizer_inventory;
			if (!is_undefined(saveDataFertilizerInventory))
			{
				structure.metadata.fertilizer_inventory.AddMultipleItems(saveDataFertilizerInventory.items);
			}
		
			var saveDataWaterInventory = structureSaveData.metadata.water_inventory;
			if (!is_undefined(saveDataWaterInventory))
			{
				structure.metadata.water_inventory.AddMultipleItems(saveDataWaterInventory.items);
			}
		
			var saveDataSeedInventory = structureSaveData.metadata.seed_inventory;
			if (!is_undefined(saveDataSeedInventory))
			{
				structure.metadata.seed_inventory.AddMultipleItems(saveDataSeedInventory.items);
			}
		
			var saveDataOutputInventory = structureSaveData.metadata.output_inventory;
			if (!is_undefined(saveDataOutputInventory))
			{
				structure.metadata.output_inventory.AddMultipleItems(saveDataOutputInventory.items);
			}
		}
	}*/
} else {
	throw (string("Object {0} with instance ID {1} is missing 'structureId'", object_get_name(object_index), id));	
}
