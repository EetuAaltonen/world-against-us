// Inherit the parent event
event_inherited();

interactionText = "Shop";
interactionFunction = function()
{
	if (electricalNetwork.electricPower > 0)
	{
		var guiState = new GUIState(
			GUI_STATE.Facility, undefined, undefined,
			[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.FacilityVendingMachine], GUI_CHAIN_RULE.OverwriteAll
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowPlayerBackpack(-1),
				CreateWindowFacilityVendingMachine(-1, facility)
			]);
		}
	}
}

var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, { columns: 10, rows: 3 }, []);
facility = new Facility(undefined, inventory, "Vending_Machine", undefined);