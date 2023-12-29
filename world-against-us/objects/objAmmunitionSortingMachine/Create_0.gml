// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Ammunition Sorting Machine";
interactionFunction = function()
{
	if (electricalNetwork.electricPower > 0)
	{
		var guiState = new GUIState(
			GUI_STATE.Facility, undefined, undefined,
			[
				CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
				CreateWindowFacilityAmmunitionSortingMachine(GAME_WINDOW.FacilityAmmunitionSortingMachine, -1, facility)
			],
			GUI_CHAIN_RULE.OverwriteAll
		);
		global.GUIStateHandlerRef.RequestGUIState(guiState);
	}
}

var inventorySize = new InventorySize(10, 3);
var inventoryFilter = new InventoryFilter([], ["Magazine", "Bullet"], []);
var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, inventorySize, inventoryFilter);
facility = new Facility(undefined, inventory, "Ammunition_Sorting_Machine", undefined);