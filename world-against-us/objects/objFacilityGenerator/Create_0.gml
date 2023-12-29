// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Open";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.Facility, undefined, undefined,
		[
			CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
			CreateWindowFacilityGenerator(GAME_WINDOW.FacilityGenerator, -1, facility)
		],
		GUI_CHAIN_RULE.OverwriteAll
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
}

var inventorySize = new InventorySize(2, 3);
var inventoryFilter = new InventoryFilter([], ["Fuel"], []);
var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, inventorySize, inventoryFilter);
facility = new Facility(undefined, inventory, "Generator", new MetadataFacilityGenerator(15, 0));