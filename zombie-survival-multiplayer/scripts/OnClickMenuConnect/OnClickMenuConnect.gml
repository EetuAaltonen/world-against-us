function OnClickMenuConnect()
{
	if (!is_undefined(global.ObjNetwork))
	{
		var addressInputElement = parentElement.GetChildElementById("MultiplayerAddressInput");
		var addressValue = global.ObjNetwork.defaultHost;
		if (!is_undefined(addressInputElement))
		{
			if (addressInputElement.input != addressInputElement.placeholder)
			{
				addressValue = addressInputElement.input;
			}
		}
		var portInputElement = parentElement.GetChildElementById("MultiplayerPortInput");
		var portValue = global.ObjNetwork.defaultPort;
		if (!is_undefined(portInputElement))
		{
			if (portInputElement.input != portInputElement.placeholder)
			{
				portValue = portInputElement.input;
			}
		}
		
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
				string("Connecting {0}:{1}...", addressValue, portValue),
				font_default, fa_center, fa_middle, c_black, 1
			)
		);
	
		// ADD NEW WINDOW
		multiplayerWindow.AddChildElements(multiplayerConnectElements);
		ds_list_add(global.ObjWindowHandler.gameWindows, multiplayerWindow);
		
		var client = global.ObjNetwork.client;
		client.CreateSocket();
		client.hostAddress = addressValue;
		client.hostPort = portValue;
		client.ConnectToHost();
	}
}