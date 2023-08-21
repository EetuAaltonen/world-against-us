// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Open";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.Facility, undefined, undefined,
		[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.FacilityGenerator], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowPlayerBackpack(-1),
			CreateWindowFacilityGenerator(-1, facility)
		]);
	}
}

var inventoryFilter = new InventoryFilter([], ["Fuel"], []);
var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, { columns: 2, rows: 3 }, inventoryFilter);
facility = new Facility(undefined, inventory, "Generator", new MetadataFacilityGenerator(15, 0));