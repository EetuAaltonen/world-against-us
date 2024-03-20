function CreateWindowDebugMonitorGameDeltaTime(_gameWindowId, _zIndex, _debugMonitorHandlerRef)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 1);
	var monitorWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var monitorElements = ds_list_create();
	
	var monitorTitlePosition = new Vector2(10, 10);
	var monitorTitleElement = new WindowText(
		"MonitorTitle",
		monitorTitlePosition,
		undefined, undefined,
		"Debug Monitor - Game", font_default, fa_left, fa_top, c_white, 1
	);
	
	// DELTA TIME GRAPH
	var monitorGraphSize = new Size(1700, 300);
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorDeltaTimeGraphElement = new WindowDebugMonitorGraph(
		"MonitorDeltaTimeGraphElement",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugMonitorHandlerRef.delta_time_samples,
		"Delta time sampling",
		"Delta time",
		_debugMonitorHandlerRef.fps_sample_interval,
		_debugMonitorHandlerRef.GetMaxDeltaTimeSamplesValue,
		"ms",
		#2bbbf2,
		undefined
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorDeltaTimeGraphElement
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}