/// @description Custom RoomStartEvent
if (!is_undefined(structureId))
{
	var structureMetadata = new MetadataStructureConstructionSite();
	structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.ConstructionSite, structureMetadata);
	
	// TODO: Fix this code
	// CHECK IF STRUCTURE HAS ROOM SAVE RECORD
	/*var structureSaveData = global.GameSaveHandlerRef.GetStructureInteractableContentById(structure.structure_id);
	if (!is_undefined(structureSaveData))
	{
		var materialSlotCount = array_length(structure.metadata.material_slots);
		for (var i = 0; i < materialSlotCount; i++)
		{
			var materialSlotInventory = structure.metadata.material_slots[@ i];
			if (!is_undefined(materialSlotInventory))
			{
				var saveDataMaterialSlotCount = array_length(structureSaveData.metadata.material_slots);
				for (var j = 0; j < saveDataMaterialSlotCount; j++)
				{
					var saveDataMaterialSlotInventory = structureSaveData.metadata.material_slots[@ j];
					if (materialSlotInventory.inventory_id == saveDataMaterialSlotInventory.inventory_id)
					{
						materialSlotInventory.AddMultipleItems(saveDataMaterialSlotInventory.items);
					}
				}
			}
		}
	}*/
}