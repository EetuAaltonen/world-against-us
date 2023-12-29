// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Build";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.ConstructionSite, undefined, undefined,
		[
			CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
			CreateWindowConstructionSite(GAME_WINDOW.ConstructionSite, -1, structure.metadata.material_slots, self)
		],
		GUI_CHAIN_RULE.OverwriteAll
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
}