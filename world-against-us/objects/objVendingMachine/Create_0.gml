// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Shop";
interactionFunction = function()
{
	if (electricalNetwork.electricPower > 0)
	{
		var guiState = new GUIState(
			GUI_STATE.Facility, undefined, undefined,
			[
				CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
				CreateWindowFacilityVendingMachine(GAME_WINDOW.FacilityVendingMachine, -1, facility)
			],
			GUI_CHAIN_RULE.OverwriteAll
		);
		global.GUIStateHandlerRef.RequestGUIState(guiState);
	}
}

var inventorySize = new InventorySize(10, 3);
var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, inventorySize);
facility = new Facility(undefined, inventory, "Vending_Machine", undefined);