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
			CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
			CreateWindowGardenBed(GAME_WINDOW.GardenBed, -1, 
				structure.metadata.tools_inventory, structure.metadata.fertilizer_inventory,
				structure.metadata.water_inventory, structure.metadata.seed_inventory,
				structure.metadata.output_inventory
			)
		]);
	}
}

structure = undefined;