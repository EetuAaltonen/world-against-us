function OnClickMenuConnect()
{
	if (!is_undefined(global.ObjNetwork))
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		var guiState = new GUIState(
			currentGUIState.index, currentGUIState.view, GUI_ACTION.Connect,
			[GAME_WINDOW.MainMenuConnect]
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
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
				CreateWindowMainMenuConnect(parentWindow.zIndex - 1, address, port)
			]);
		}
	}
}