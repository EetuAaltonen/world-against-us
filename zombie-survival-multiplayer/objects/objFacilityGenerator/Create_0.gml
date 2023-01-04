// Inherit the parent event
event_inherited();

interactionText = "Open";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.Facility, undefined, undefined,
		[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.FacilityGenerator], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandler.RequestGUIState(guiState))
	{
		global.GameWindowHandler.OpenWindowGroup([
			CreateWindowPlayerBackpack(-1),
			CreateWindowFacilityGenerator(-1, facility)
		]);
	}
}

var inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, { columns: 2, rows: 3 }, ["Fuel"]);
facility = new FacilityGenerator(undefined, inventory, 15);