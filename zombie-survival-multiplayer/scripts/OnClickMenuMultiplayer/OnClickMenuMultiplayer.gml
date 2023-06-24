function OnClickMenuMultiplayer()
{
	var guiState = new GUIState(
		global.GUIStateHandlerRef.GetGUIState().index, GUI_VIEW.Multiplayer, undefined,
		[GAME_WINDOW.MainMenuMultiplayer]
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowMainMenuMultiplayer(parentWindow.zIndex - 1)
		]);
	}
}