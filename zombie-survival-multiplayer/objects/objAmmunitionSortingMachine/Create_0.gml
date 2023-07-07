// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Ammunition Sorting Machine";
interactionFunction = function()
{
	if (electricalNetwork.electricPower > 0)
	{
		var guiState = new GUIState(
			GUI_STATE.Facility, undefined, undefined,
			[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.FacilityAmmunitionSortingMachine], GUI_CHAIN_RULE.OverwriteAll
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowPlayerBackpack(-1),
				CreateWindowFacilityAmmunitionSortingMachine(-1, facility)
			]);
		}
	}
}

var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, { columns: 10, rows: 3 }, ["Magazine", "Bullet"]);
facility = new Facility(undefined, inventory, "Ammunition_Sorting_Machine", undefined);