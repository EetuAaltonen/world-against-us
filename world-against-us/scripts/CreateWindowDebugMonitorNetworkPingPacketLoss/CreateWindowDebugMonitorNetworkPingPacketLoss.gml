function CreateWindowDebugMonitorNetworkPingPacketLoss(_gameWindowId, _zIndex, _debugNetworkHandlerRef)
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
	
	// PING GRAPH
	var monitorGraphSize = new Size(1700, 300);
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorPingGraphElement = new WindowDebugMonitorGraph(
		"MonitorPingGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugNetworkHandlerRef.ping_samples,
		"Ping sampling",
		"Ping",
		_debugNetworkHandlerRef.ping_sample_interval,
		_debugNetworkHandlerRef.GetMaxPingSamplesValue,
		"ms",
		#2bbbf2,
		undefined
	);
	
	// PACKET LOSS GRAPH
	monitorGraphPosition = new Vector2(80, 570);
	var monitorPacketLossGraphElement = new WindowDebugMonitorGraph(
		"MonitorPacketLossGraph",
		monitorGraphPosition,
		monitorGraphSize,
		undefined,
		_debugNetworkHandlerRef.packet_loss_samples,
		"Overall packet loss count sampling",
		"Total count",
		undefined,
		_debugNetworkHandlerRef.GetMaxPacketLossSamplesValue,
		"count",
		#2bbbf2,
		#f2a035
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorPingGraphElement,
		monitorPacketLossGraphElement
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}