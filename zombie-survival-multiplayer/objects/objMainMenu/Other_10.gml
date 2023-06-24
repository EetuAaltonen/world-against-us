/// @description Custom RoomStartEvent
// OPEN MAIN MENU ROOT WINDOW
var guiState = new GUIState(
	GUI_STATE.MainMenu, undefined, undefined,
	[GAME_WINDOW.MainMenuRoot]
);
if (global.GUIStateHandlerRef.RequestGUIState(guiState))
{
	global.GameWindowHandlerRef.OpenWindowGroup([
		CreateWindowMainMenuRoot(0)
	]);
}