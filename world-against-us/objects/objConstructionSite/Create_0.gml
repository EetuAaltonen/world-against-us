// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Build";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.ConstructionSite, undefined, undefined,
		[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.ConstructionSite], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
			CreateWindowConstructionSite(GAME_WINDOW.ConstructionSite, -1, structure.metadata.material_slots, self)
		]);
	}
}

structure = undefined;