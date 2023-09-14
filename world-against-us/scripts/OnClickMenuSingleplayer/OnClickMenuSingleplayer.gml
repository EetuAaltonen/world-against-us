function OnClickMenuSingleplayer()
{
	var guiState = new GUIState(
		global.GUIStateHandlerRef.GetGUIState().index, GUI_VIEW.Singleplayer, undefined,
		[GAME_WINDOW.MainMenuSingleplayer]
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowMainMenuSingleplayer(GAME_WINDOW.MainMenuSingleplayer, parentWindow.zIndex - 1)
		]);
	}
}