function CallbackGUIStateInputDebugMonitor()
{
	var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
	if (currentGUIState.index == GUI_STATE.DebugMonitor)
	{
		if (keyboard_check_released(ord("1")))
		{
			// OPEN GAME MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorGame, [
				CreateWindowDebugMonitorGame(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorGameHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		} else if (keyboard_check_released(ord("2")))
		{
			// OPEN NETWORK MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorNetwork, [
				CreateWindowDebugMonitorNetwork(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorNetworkHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		}
	}
}