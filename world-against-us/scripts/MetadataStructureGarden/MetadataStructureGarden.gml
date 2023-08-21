function MetadataStructureGarden() : Metadata() constructor
{
	tools_inventory = new Inventory("GardenBedTools", INVENTORY_TYPE.Garden, { columns: 2, rows: 2 }, new InventoryFilter(["Garden Tools"], [], []));
	fertilizer_inventory = new Inventory("GardenBedFertilizer", INVENTORY_TYPE.Garden, { columns: 2, rows: 3 }, new InventoryFilter(["Fertilizer Sack"], [], []));
	water_inventory = new Inventory("GardenBedWater", INVENTORY_TYPE.Garden, { columns: 2, rows: 3 }, new InventoryFilter(["Watering Can"], [], []));
	seed_inventory = new Inventory("GardenBedSeed", INVENTORY_TYPE.Garden, { columns: 1, rows: 1 }, new InventoryFilter(["Tomato Seed Pack"], [], []));
	output_inventory = new Inventory("GardenBedOutput", INVENTORY_TYPE.Garden, { columns: 10, rows: 4 }, new InventoryFilter([], ["Consumable"], []));
	
	static ToJSONStruct = function()
	{
		var formatToolsInventory = (!is_undefined(tools_inventory)) ? tools_inventory.ToJSONStruct() : undefined;
		var formatFertilizerInventory = (!is_undefined(fertilizer_inventory)) ? fertilizer_inventory.ToJSONStruct() : undefined;
		var formatWaterInventory = (!is_undefined(water_inventory)) ? water_inventory.ToJSONStruct() : undefined;
		var formatSeedInventory = (!is_undefined(seed_inventory)) ? seed_inventory.ToJSONStruct() : undefined;
		var formatOutputInventory = (!is_undefined(output_inventory)) ? output_inventory.ToJSONStruct() : undefined;
		
		return {
			tools_inventory: formatToolsInventory,
			fertilizer_inventory: formatFertilizerInventory,
			water_inventory: formatWaterInventory,
			seed_inventory: formatSeedInventory,
			output_inventory: formatOutputInventory
		}
	}
}