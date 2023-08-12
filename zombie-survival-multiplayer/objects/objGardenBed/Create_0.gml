// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Look at";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.Garden, undefined, undefined,
		[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.GardenBed], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowPlayerBackpack(-1),
			CreateWindowGardenBed(-1, toolsInventory, fertilizeInventory, waterInventory, seedInventory, outputInventory)
		]);
	}
}

toolsInventory = new Inventory("GardenBedTools", INVENTORY_TYPE.Garden, { columns: 2, rows: 2 }, ["Garden Tools"]);
fertilizeInventory = new Inventory("GardenBedFertilizer", INVENTORY_TYPE.Garden, { columns: 2, rows: 3 }, ["Fertilizer Sack"]);
waterInventory = new Inventory("GardenBedWater", INVENTORY_TYPE.Garden, { columns: 2, rows: 3 }, ["Watering Can"]);
seedInventory = new Inventory("GardenBedSeed", INVENTORY_TYPE.Garden, { columns: 1, rows: 1 }, ["Tomato Seed Pack"]);
outputInventory = new Inventory("GardenBedOutput", INVENTORY_TYPE.Garden, { columns: 10, rows: 4 }, ["Consumable"]);