function OnClickOperationsScoutList()
{
	// OPEN OPERATIONS SCOUT LIST
	var operationsCenterWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenter);
	if (!is_undefined(operationsCenterWindow))
	{
		if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.OperationsCenterScoutList, [GAME_WINDOW.OperationsCenterScoutList]))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowOperationsScoutList(GAME_WINDOW.OperationsCenterScoutList, operationsCenterWindow.zIndex - 1)
			]);	
		}
	}
}