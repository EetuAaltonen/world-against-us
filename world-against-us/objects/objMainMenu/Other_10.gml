/// @description Custom RoomStartEvent
// OPEN MAIN MENU ROOT WINDOW
var guiState = new GUIState(
	GUI_STATE.MainMenu, undefined, undefined,
	[GAME_WINDOW.MainMenuRoot], GUI_CHAIN_RULE.OverwriteAll
);
if (global.GUIStateHandlerRef.RequestGUIState(guiState))
{
	global.GameWindowHandlerRef.OpenWindowGroup([
		CreateWindowMainMenuRoot(GAME_WINDOW.MainMenuRoot, 0)
	]);
}