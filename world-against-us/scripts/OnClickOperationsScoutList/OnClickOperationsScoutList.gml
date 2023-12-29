function OnClickOperationsScoutList()
{
	// OPEN OPERATIONS SCOUT LIST
	var operationsCenterWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenter);
	if (!is_undefined(operationsCenterWindow))
	{
		global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.OperationsCenterScoutList, [
			CreateWindowOperationsScoutList(GAME_WINDOW.OperationsCenterScoutList, operationsCenterWindow.zIndex - 1)
		], GUI_CHAIN_RULE.Append);
	}
}