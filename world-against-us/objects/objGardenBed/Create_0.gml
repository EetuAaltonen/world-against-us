// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Look at";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.Garden, undefined, undefined,
		[
			CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
			CreateWindowGardenBed(GAME_WINDOW.GardenBed, -1, 
				structure.metadata.tools_inventory, structure.metadata.fertilizer_inventory,
				structure.metadata.water_inventory, structure.metadata.seed_inventory,
				structure.metadata.output_inventory
			)
		],
		GUI_CHAIN_RULE.OverwriteAll
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
}