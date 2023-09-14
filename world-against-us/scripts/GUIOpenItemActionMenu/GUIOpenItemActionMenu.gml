function GUIOpenItemActionMenu(_targetItem)
{
	if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.ItemActionMenu, [GAME_WINDOW.ItemActionMenu]))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowItemActionMenu(GAME_WINDOW.ItemActionMenu, parentWindow.zIndex - 1, _targetItem)
		]);
	}
}