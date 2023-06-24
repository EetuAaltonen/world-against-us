function GUIOpenItemActionMenu(_targetItem)
{
	var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
	var guiState = new GUIState(
		currentGUIState.index, currentGUIState.view, GUI_ACTION.ItemActionMenu,
		[GAME_WINDOW.ItemActionMenu]
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowItemActionMenu(parentWindow.zIndex - 1, _targetItem)
		]);
	}
}