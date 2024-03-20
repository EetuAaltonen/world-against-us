function CreateWindowDebugMonitorMultiplayerEntityFastTravel(_gameWindowId, _zIndex, _debugMultiplayerHandlerRef)
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
		"Debug Monitor - Multiplayer", font_default, fa_left, fa_top, c_white, 1
	);
	
	// NETWORK ENTITY GRAPH
	var monitorGraphSize = new Size(1700, 300);
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorNetworkEntitiesGraphElement = new WindowDebugMonitorGraph(
		"MonitorNetworkEntitiesGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugMultiplayerHandlerRef.network_entities_samples,
		"Network entity count sampling",
		"Entity count (active)",
		_debugMultiplayerHandlerRef.network_entities_sample_interval,
		_debugMultiplayerHandlerRef.GetMaxEntitiesSamplesValue,
		"count",
		#2bbbf2,
		#f2a035
	);
	
	// FAST TRAVEL TIME GRAPH
	monitorGraphPosition = new Vector2(80, 570);
	var monitorFastTravelTimeGraphElement = new WindowDebugMonitorGraph(
		"MonitorFastTravelTimeGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugMultiplayerHandlerRef.fast_travel_time_samples,
		"Overall fast travel time sampling",
		"Fast travel time",
		undefined,
		_debugMultiplayerHandlerRef.GetMaxFastTravelTimeValue,
		"ms",
		#2bbbf2,
		#f2a035
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorNetworkEntitiesGraphElement,
		monitorFastTravelTimeGraphElement,
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}