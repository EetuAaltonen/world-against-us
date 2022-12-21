function GUIOpenItemActionMenu(_targetItem)
{
	var currentGUIState = global.GUIStateHandler.GetGUIState();
	var guiState = new GUIState(
		currentGUIState.index, currentGUIState.view, GUI_ACTION.ItemActionMenu,
		[GAME_WINDOW.ItemActionMenu]
	);
	if (global.GUIStateHandler.RequestGUIState(guiState))
	{
		global.GameWindowHandler.OpenWindowGroup([
			CreateWindowItemActionMenu(parentWindow.zIndex - 1, _targetItem)
		]);
	}
}