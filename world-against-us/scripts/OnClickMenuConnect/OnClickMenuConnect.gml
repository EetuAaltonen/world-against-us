function OnClickMenuConnect()
{
	var multiplayerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuMultiplayer);
	if (!is_undefined(multiplayerWindow))
	{
		var multiplayerPanelElement = multiplayerWindow.GetChildElementById("MultiplayerPanel");
		if (!is_undefined(multiplayerPanelElement))
		{
			var addressInputElement = multiplayerPanelElement.GetChildElementById("MultiplayerAddressInput");
			var portInputElement = multiplayerPanelElement.GetChildElementById("MultiplayerPortInput");
			if (!is_undefined(addressInputElement) && !is_undefined(portInputElement))
			{
				// TODO: Validate address and port input
				var address = addressInputElement.input;
				var port = portInputElement.input;
				if (global.NetworkHandlerRef.CreateSocket())
				{
					if (global.NetworkHandlerRef.RequestConnectSocket(address, port))
					{
						if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.Connect, [GAME_WINDOW.MainMenuConnect]))
						{
							global.GameWindowHandlerRef.OpenWindowGroup([
								CreateWindowMainMenuConnect(GAME_WINDOW.MainMenuConnect, parentWindow.zIndex - 1, address, port)
							]);
						}
					}
				} else {
					// TODO: Generic error handling
					show_message("Failed to create a socket!");
				}
			}
		}
	}
}