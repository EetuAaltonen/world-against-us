debugMonitorGameHandler.Update();
if (global.MultiplayerMode)
{
	debugMonitorMultiplayerHandler.Update();
}

if (keyboard_check_released(KEY_DEBUG_MONITOR))
{
	var guiState = new GUIState(
		GUI_STATE.DebugMonitor, GUI_VIEW.DebugMonitorGameFPS, undefined,
		[
			CreateWindowDebugMonitorGameFps(GAME_WINDOW.DebugMonitor, -1, debugMonitorGameHandler)
		],
		GUI_CHAIN_RULE.OverwriteAll,
		CallbackGUIStateInputDebugMonitor, undefined
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
} else if (keyboard_check_released(KEY_DEBUG_OVERLAY))
{
	showDebugOverlay = !showDebugOverlay;
	show_debug_overlay(showDebugOverlay, false, 1.2, 1);
}