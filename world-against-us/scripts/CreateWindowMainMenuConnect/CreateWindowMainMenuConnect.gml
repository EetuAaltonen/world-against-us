function CreateWindowMainMenuConnect(_gameWindowId, _zIndex, _address, _port)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(#7d9ac7, 1);
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
	
	// CONNECTING TITLE
	ds_list_add(multiplayerConnectElements,
		connectingTitle
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnClose = function()
	{
		// DISCONNECT FROM A HOST IF CONNECTING INTERRUPTED
		if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.CONNECTING)
		{
			global.NetworkHandlerRef.RequestDisconnectSocket(true);
		}
	}
	multiplayerConnectWindow.OnClose = overrideOnClose;
	multiplayerConnectWindow.AddChildElements(multiplayerConnectElements);
	return multiplayerConnectWindow;
}