function CallbackGUIStateInputDebugMonitor()
{
	var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
	if (currentGUIState.index == GUI_STATE.DebugMonitor)
	{
		if (keyboard_check_released(ord("1")))
		{
			// OPEN GAME FPS MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorGameFPS, [
				CreateWindowDebugMonitorGameFps(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorGameHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		} else if (keyboard_check_released(ord("2")))
		{
			// OPEN GAME DELTA TIME MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorGameDeltaTime, [
				CreateWindowDebugMonitorGameDeltaTime(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorGameHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		} else if (keyboard_check_released(ord("3")))
		{
			// OPEN NETWORK MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorNetworkPingPacketLoss, [
				CreateWindowDebugMonitorNetworkPingPacketLoss(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorNetworkHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		} else if (keyboard_check_released(ord("4")))
		{
			// OPEN MULTIPLAYER MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorNetworkDataRate, [
				CreateWindowDebugMonitorNetworkDataRate(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorNetworkHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		} else if (keyboard_check_released(ord("5")))
		{
			// OPEN MULTIPLAYER MONITORING
			global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.DebugMonitorMultiplayerEntityFastTravel, [
				CreateWindowDebugMonitorMultiplayerEntityFastTravel(GAME_WINDOW.DebugMonitor, -1, global.DebugMonitorMultiplayerHandlerRef)
			], GUI_CHAIN_RULE.OverwriteAll);
		}
	}
}