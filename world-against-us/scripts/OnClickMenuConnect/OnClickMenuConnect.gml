function OnClickMenuConnect()
{
	if (!is_undefined(global.ObjNetwork))
	{
		if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.Connect, [GAME_WINDOW.MainMenuConnect]))
		{
			var addressInputElement = parentElement.GetChildElementById("MultiplayerAddressInput");
			var address = global.ObjNetwork.defaultHost;
			if (!is_undefined(addressInputElement))
			{
				if (addressInputElement.input != addressInputElement.placeholder)
				{
					address = addressInputElement.input;
				}
			}
			var portInputElement = parentElement.GetChildElementById("MultiplayerPortInput");
			var port = global.ObjNetwork.defaultPort;
			if (!is_undefined(portInputElement))
			{
				if (portInputElement.input != portInputElement.placeholder)
				{
					port = portInputElement.input;
				}
			}
			
			var client = global.ObjNetwork.client;
			client.CreateSocket();
			client.hostAddress = address;
			client.hostPort = port;
			client.ConnectToHost();
		
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowMainMenuConnect(GAME_WINDOW.MainMenuConnect, parentWindow.zIndex - 1, address, port)
			]);
		}
	}
}