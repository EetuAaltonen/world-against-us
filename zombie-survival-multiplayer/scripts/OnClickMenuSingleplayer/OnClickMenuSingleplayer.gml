function OnClickMenuSingleplayer()
{
	var guiState = new GUIState(
		global.GUIStateHandler.GetGUIState().index, GUI_VIEW.Singleplayer, undefined,
		[GAME_WINDOW.MainMenuSingleplayer]
	);
	if (global.GUIStateHandler.RequestGUIState(guiState))
	{
		global.GameWindowHandler.OpenWindowGroup([
			CreateWindowMainMenuSingleplayer(parentWindow.zIndex - 1)
		]);
	}
}