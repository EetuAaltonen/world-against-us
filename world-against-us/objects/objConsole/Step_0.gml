if (keyboard_check_released(KEY_CONSOLE))
{
	var appendWindowIndex = -1;
	var mostTopWindow = global.GameWindowHandlerRef.GetTopMostWindow();
	if (!is_undefined(mostTopWindow))
	{
		appendWindowIndex = mostTopWindow.zIndex - 1;
	}
					
	var consoleMessages = ds_list_create();
	ds_list_copy(consoleMessages, global.ConsoleHandlerRef.console_logs);
	var guiState = new GUIState(
		GUI_STATE.Console, undefined, undefined,
		[GAME_WINDOW.Console], GUI_CHAIN_RULE.Append,
		undefined, undefined
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowConsole(GAME_WINDOW.Console, appendWindowIndex, consoleMessages)
		]);
	}
}