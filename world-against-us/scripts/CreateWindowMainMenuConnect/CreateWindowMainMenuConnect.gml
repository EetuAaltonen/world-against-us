function CreateWindowMainMenuConnect(_gameWindowId, _zIndex, _address, _port)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(#217fb5, 1);
	var multiplayerConnectWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);	
	
	var multiplayerConnectElements = ds_list_create();
	
	var connectingTitle = new WindowText(
		"ConnectTitle",
		new Vector2(windowSize.w * 0.5, 500),
		undefined, undefined,
		string("Connecting {0}:{1}...", _address, _port),
		font_default, fa_center, fa_middle, c_black, 1
	);
	
	var timeoutTimerTitle = new WindowText(
		"TimeoutTimerTitle",
		new Vector2(windowSize.w * 0.5, 600),
		undefined, undefined,
		EMPTY_STRING,
		font_default, fa_center, fa_middle, c_black, 1
	);
	
	// CONNECTING TITLE
	ds_list_add(multiplayerConnectElements,
		connectingTitle,
		timeoutTimerTitle
	);
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// FORCE STOP CONNECTING
		global.NetworkHandlerRef.network_status = NETWORK_STATUS.OFFLINE;
		global.NetworkHandlerRef.timeout_timer.running_time = 0;
	}
	multiplayerConnectWindow.OnClose = overrideOnClose;
	
	multiplayerConnectWindow.AddChildElements(multiplayerConnectElements);
	return multiplayerConnectWindow;
}