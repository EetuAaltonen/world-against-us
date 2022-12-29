// OPEN MAIN MENU ROOT WINDOW
var guiState = new GUIState(
	GUI_STATE.MainMenu, undefined, undefined,
	[GAME_WINDOW.MainMenuRoot]
);
if (global.GUIStateHandler.RequestGUIState(guiState))
{
	global.GameWindowHandler.OpenWindowGroup([
		CreateWindowMainMenuRoot(0)
	]);
}