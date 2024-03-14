function OnClickMenuConnect()
{
	var multiplayerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuMultiplayer);
	if (!is_undefined(multiplayerWindow))
	{
		var multiplayerPanelElement = multiplayerWindow.GetChildElementById("MultiplayerPanel");
		if (!is_undefined(multiplayerPanelElement))
		{
			var playerTagInputElement = multiplayerPanelElement.GetChildElementById("MultiplayerPlayerTagInput");
			var addressInputElement = multiplayerPanelElement.GetChildElementById("MultiplayerAddressInput");
			var portInputElement = multiplayerPanelElement.GetChildElementById("MultiplayerPortInput");
			if (!is_undefined(playerTagInputElement) &&
				!is_undefined(addressInputElement) &&
				!is_undefined(portInputElement))
			{
				var playerTag = playerTagInputElement.input;
				var address = addressInputElement.input;
				var port = portInputElement.input;
				if (ValidateMultiplayerConnectionDetails(playerTagInputElement, addressInputElement, portInputElement))
				{
					if (global.NetworkHandlerRef.CreateSocket())
					{
						if (global.NetworkHandlerRef.RequestConnectSocket(playerTag, address, port))
						{
							global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.Connect, [
								CreateWindowMainMenuConnect(GAME_WINDOW.MainMenuConnect, parentWindow.zIndex - 1, address, port)
							], GUI_CHAIN_RULE.Append);
						}
					} else {
						// TODO: Generic error handling
						show_message("Failed to create a socket!");
					}
				}
			}
		}
	}
}