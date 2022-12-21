function OnClickMenuMultiplayer()
{
	var guiState = new GUIState(
		global.GUIStateHandler.GetGUIState().index, GUI_VIEW.Multiplayer, undefined,
		[GAME_WINDOW.MainMenuMultiplayer]
	);
	if (global.GUIStateHandler.RequestGUIState(guiState))
	{
		global.GameWindowHandler.OpenWindowGroup([
			CreateWindowMainMenuMultiplayer(parentWindow.zIndex - 1)
		]);
	}
}