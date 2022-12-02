function OnClickMenuConnect()
{
	if (!is_undefined(global.ObjNetwork))
	{
		var windowSize = new Size(global.GUIW, global.GUIH);
		var windowStyle = new GameWindowStyle(#217fb5, 1);
	
		var multiplayerWindow = new GameWindow(
			"MultiplayerConnectWindow",
			new Vector2(0, 0),
			windowSize, windowStyle, parentWindow.zIndex - 1
		);	
	
		var multiplayerConnectElements = ds_list_create();
		// CONNECTING TITLE
		ds_list_add(multiplayerConnectElements,
			new WindowText(
				"MultiplayerConnectTitle",
				new Vector2(windowSize.w * 0.5, windowSize.h * 0.5),
				undefined, undefined,
				"Connecting " + string(global.ObjNetwork.defaultHost) + ":" + string(global.ObjNetwork.defaultPort) + "....",
				font_default, fa_center, fa_middle, c_black, 1
			)
		);
	
		// ADD NEW WINDOW
		multiplayerWindow.AddChildElements(multiplayerConnectElements);
		ds_list_add(global.ObjWindowHandler.gameWindows, multiplayerWindow);
		
		var client = global.ObjNetwork.client;
		client.CreateSocket();
		client.hostAddress = global.ObjNetwork.defaultHost;
		client.hostPort = global.ObjNetwork.defaultPort;
		client.ConnectToHost();
	}
}