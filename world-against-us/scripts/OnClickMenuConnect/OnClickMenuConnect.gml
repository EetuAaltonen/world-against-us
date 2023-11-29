function OnClickMenuConnect()
{
	if (!is_undefined(global.NetworkHandlerRef))
	{
		if (global.NetworkHandlerRef.CreateSocket())
		{
			var address = DEFAULT_HOST_ADDRESS;
			var port = DEFAULT_HOST_PORT;
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