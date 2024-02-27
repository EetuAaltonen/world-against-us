function CreateWindowDebugMonitorGame(_gameWindowId, _zIndex, _debugMonitorHandlerRef)
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
	
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorGraphSize = new Size(800, 300);
	// FPS GRAPH
	var fpsSamplesClone = [];
	array_copy(
		fpsSamplesClone, 0,
		_debugMonitorHandlerRef.fps_samples, 0,
		array_length(_debugMonitorHandlerRef.fps_samples)
	);
	var monitorFPSGraphElement = new WindowDebugMonitorGraph(
		"MonitorFPSGraphElement",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		fpsSamplesClone,
		"FPS sampling",
		"FPS",
		_debugMonitorHandlerRef.fps_sample_interval,
		_debugMonitorHandlerRef.fps_samples_max_value,
		"framerate",
		#2bbbf2,
		undefined
	);
	
	// FPS REAL GRAPH
	var fpsRealSamplesClone = [];
	array_copy(
		fpsRealSamplesClone, 0,
		_debugMonitorHandlerRef.fps_real_samples, 0,
		array_length(_debugMonitorHandlerRef.fps_real_samples)
	);
	monitorGraphPosition = new Vector2(970, 150);
	var monitorFPSRealGraphElement = new WindowDebugMonitorGraph(
		"MonitorFPSRealGraphElement",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		fpsRealSamplesClone,
		"FPS real sampling",
		"FPS real",
		_debugMonitorHandlerRef.fps_sample_interval,
		_debugMonitorHandlerRef.fps_real_samples_max_value,
		"framerate",
		#2bbbf2,
		undefined
	);
	
	// DELTA TIME GRAPH
	var deltaTimeSamplesClone = [];
	array_copy(
		deltaTimeSamplesClone, 0,
		_debugMonitorHandlerRef.delta_time_samples, 0,
		array_length(_debugMonitorHandlerRef.delta_time_samples)
	);
	monitorGraphPosition = new Vector2(80, 570);
	var monitorDeltaTimeGraphElement = new WindowDebugMonitorGraph(
		"MonitorDeltaTimeGraphElement",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		deltaTimeSamplesClone,
		"Delta time sampling",
		"Delta time",
		_debugMonitorHandlerRef.fps_sample_interval,
		_debugMonitorHandlerRef.delta_time_samples_max_value,
		"ms",
		#2bbbf2,
		undefined
	);
	
	// MEMORY USAGE GRAPH
	var memoryUsageSamplesClone = [];
	array_copy(
		memoryUsageSamplesClone, 0,
		_debugMonitorHandlerRef.memory_usage_samples, 0,
		array_length(_debugMonitorHandlerRef.memory_usage_samples)
	);
	monitorGraphPosition = new Vector2(970, 570);
	var monitormemoryUsageGraphElement = new WindowDebugMonitorGraph(
		"MonitorMemoryUsageGraphElement",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		memoryUsageSamplesClone,
		"Memory usage sampling",
		"Memory usage",
		_debugMonitorHandlerRef.fps_sample_interval,
		_debugMonitorHandlerRef.memory_usage_samples_max_value,
		"MB",
		#2bbbf2,
		undefined
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorFPSGraphElement,
		monitorFPSRealGraphElement,
		monitorDeltaTimeGraphElement,
		monitormemoryUsageGraphElement
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}