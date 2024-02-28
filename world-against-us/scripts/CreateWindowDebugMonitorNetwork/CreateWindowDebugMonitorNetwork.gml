function CreateWindowDebugMonitorNetwork(_gameWindowId, _zIndex, _debugNetworkHandlerRef)
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
	
	var monitorGraphPosition = new Vector2(80, 150);
	var monitorGraphSize = new Size(800, 300);
	var pingSamplesClone = [];
	array_copy(
		pingSamplesClone, 0,
		_debugNetworkHandlerRef.ping_samples, 0,
		array_length(_debugNetworkHandlerRef.ping_samples)
	);
	var monitorPingGraphElement = new WindowDebugMonitorGraph(
		"MonitorPingGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		pingSamplesClone,
		"Ping sampling",
		"Ping",
		_debugNetworkHandlerRef.ping_sample_interval,
		_debugNetworkHandlerRef.ping_samples_max_value,
		"ms",
		#2bbbf2,
		undefined
	);
	
	monitorGraphPosition = new Vector2(970, 150);
	var packetDropSamplesClone = [];
	array_copy(
		packetDropSamplesClone, 0,
		_debugNetworkHandlerRef.packet_loss_samples, 0,
		array_length(_debugNetworkHandlerRef.packet_loss_samples)
	);
	var monitorPacketLossGraphElement = new WindowDebugMonitorGraph(
		"MonitorPacketLossGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		packetDropSamplesClone,
		"Over time packet loss count sampling",
		"Total count",
		undefined,
		_debugNetworkHandlerRef.packet_loss_samples_max_value,
		"count",
		#2bbbf2,
		#f2a035
	);
	
	monitorGraphPosition = new Vector2(80, 570);
	var dataOutSamplesClone = [];
	array_copy(
		dataOutSamplesClone, 0,
		_debugNetworkHandlerRef.data_out_samples, 0,
		array_length(_debugNetworkHandlerRef.data_out_samples)
	);
	var monitorDataOutGraphElement = new WindowDebugMonitorGraph(
		"MonitorDataOutGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		dataOutSamplesClone,
		"Sent data sampling",
		"Data rate (out)",
		_debugNetworkHandlerRef.data_rate_sample_interval,
		_debugNetworkHandlerRef.data_out_samples_max_value,
		"kb/s",
		#2bbbf2,
		undefined
	);
	
	monitorGraphPosition = new Vector2(970, 570);
	var dataInSamplesClone = [];
	array_copy(
		dataInSamplesClone, 0,
		_debugNetworkHandlerRef.data_in_samples, 0,
		array_length(_debugNetworkHandlerRef.data_in_samples)
	);
	var monitorDataInGraphElement = new WindowDebugMonitorGraph(
		"MonitorDataInGraph",
		monitorGraphPosition,
		monitorGraphSize,
		#1f1f1f,
		dataInSamplesClone,
		"Received data sampling",
		"Data rate (in)",
		_debugNetworkHandlerRef.data_rate_sample_interval,
		_debugNetworkHandlerRef.data_in_samples_max_value,
		"kb/s",
		#2bbbf2,
		undefined
	);
	
	ds_list_add(monitorElements,
		monitorTitleElement,
		monitorPingGraphElement,
		monitorPacketLossGraphElement,
		monitorDataOutGraphElement,
		monitorDataInGraphElement
	);
	
	monitorWindow.AddChildElements(monitorElements);
	return monitorWindow;
}