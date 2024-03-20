function CreateWindowDebugMonitorNetworkDataRate(_gameWindowId, _zIndex, _debugNetworkHandlerRef)
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
		"Debug Monitor - Network", font_default, fa_left, fa_top, c_white, 1
	);
	
	// DATA OUT RATE GRAPH
	var monitorGraphSize = new Size(1700, 300);
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorDataOutGraphElement = new WindowDebugMonitorGraph(
		"MonitorDataOutGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugNetworkHandlerRef.data_out_samples,
		"Sent data sampling",
		"Data rate (out)",
		_debugNetworkHandlerRef.data_rate_sample_interval,
		_debugNetworkHandlerRef.GetMaxDataOutRateSamplesValue,
		"kb/s",
		#2bbbf2,
		undefined
	);
	
	// DATA IN RATE GRAPH
	monitorGraphPosition = new Vector2(80, 570);
	var monitorDataInGraphElement = new WindowDebugMonitorGraph(
		"MonitorDataInGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugNetworkHandlerRef.data_in_samples,
		"Received data sampling",
		"Data rate (in)",
		_debugNetworkHandlerRef.data_rate_sample_interval,
		_debugNetworkHandlerRef.GetMaxDataInRateSamplesValue,
		"kb/s",
		#2bbbf2,
		undefined
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorDataOutGraphElement,
		monitorDataInGraphElement
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}