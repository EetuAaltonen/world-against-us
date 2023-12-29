function GUIOpenItemActionMenu(_targetItem)
{
	global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.ItemActionMenu, [
		CreateWindowItemActionMenu(GAME_WINDOW.ItemActionMenu, parentWindow.zIndex - 1, _targetItem)
	], GUI_CHAIN_RULE.Append);
}