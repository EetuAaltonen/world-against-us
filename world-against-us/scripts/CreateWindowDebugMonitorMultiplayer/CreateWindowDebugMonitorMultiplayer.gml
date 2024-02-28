function CreateWindowDebugMonitorMultiplayer(_gameWindowId, _zIndex, _debugMultiplayerHandlerRef)
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
	
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorGraphSize = new Size(800, 300);
	var networkEntitiesSamplesClone = [];
	array_copy(
		networkEntitiesSamplesClone, 0,
		_debugMultiplayerHandlerRef.network_entities_samples, 0,
		array_length(_debugMultiplayerHandlerRef.network_entities_samples)
	);
	var monitorNetworkEntitiesGraphElement = new WindowDebugMonitorGraph(
		"MonitorNetworkEntitiesGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		networkEntitiesSamplesClone,
		"Network entity count sampling",
		"Entity count (active)",
		_debugMultiplayerHandlerRef.network_entities_sample_interval,
		_debugMultiplayerHandlerRef.network_entities_samples_max_value,
		"count",
		#2bbbf2,
		#f2a035
	);
	
	monitorGraphPosition = new Vector2(970, 150);
	var fastTravelTimeSamplesClone = [];
	array_copy(
		fastTravelTimeSamplesClone, 0,
		_debugMultiplayerHandlerRef.fast_travel_time_samples, 0,
		array_length(_debugMultiplayerHandlerRef.fast_travel_time_samples)
	);
	var monitorFastTravelTimeGraphElement = new WindowDebugMonitorGraph(
		"MonitorFastTravelTimeGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		fastTravelTimeSamplesClone,
		"Overall fast travel time sampling",
		"Fast travel time",
		undefined,
		_debugMultiplayerHandlerRef.fast_travel_time_samples_max_value,
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