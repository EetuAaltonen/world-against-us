function MetadataStructureConstructionSite() : Metadata() constructor
{
	material_slots = [];
	
	InitMaterialSlots();
	
	static ToJSONStruct = function()
	{
		var formatMaterialSlotInventories = [];
		
		var materialSlotCount = array_length(material_slots);
		for (var i = 0; i < materialSlotCount; i++)
		{
			var materialSlotInventory = material_slots[@ i];
			if (!is_undefined(materialSlotInventory))
			{
				var formatMaterialSlotInventory = materialSlotInventory.ToJSONStruct();
				array_push(formatMaterialSlotInventories, formatMaterialSlotInventory);
			}
		}
		
		return {
			material_slots: formatMaterialSlotInventories
		}
	}
	
	static InitMaterialSlots = function()
	{
		var inventorySize = new InventorySize(4, 4);
		var inventoryFilter = new InventoryFilter([], ["Material"], []);
		var materialSlotCount = 3;
		for (var i = 0; i < materialSlotCount; i++)
		{
			var materialSlotInventory = new Inventory(string("MaterialSlot{0}", i), INVENTORY_TYPE.ConstructionSite, inventorySize, inventoryFilter);
			array_push(material_slots, materialSlotInventory);
		}
	}
}