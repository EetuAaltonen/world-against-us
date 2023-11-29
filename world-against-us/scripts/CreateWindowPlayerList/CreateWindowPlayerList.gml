function CreateWindowPlayerList(_gameWindowId, _zIndex)
{
	var windowSize = new Size(900, 600);
	var windowPosition = new Vector2(
		(global.GUIW * 0.5) - (windowSize.w * 0.5),
		(global.GUIH * 0.5) - (windowSize.h * 0.5)
	);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var playerListWindow = new GameWindow(
		_gameWindowId,
		windowPosition,
		windowSize,
		windowStyle,
		_zIndex
	);
	
	var playerListElements = ds_list_create();
	var playerListInfoPanelElements = ds_list_create();
	
	// INFO PANEL
	var infoPanelSize = new Size(windowSize.w, 40);
	var playerListInfoPanel = new WindowPanel(
		"PlayerListInfoPanel",
		new Vector2(0, 0),
		infoPanelSize,
		c_dkgrey
	);
	
	// INFO PANEL TITLE
	var playerListTitle = new WindowText(
		"PlayerListTitle",
		new Vector2(10, 20),
		undefined, undefined,
		"Player list",
		font_default, fa_left, fa_middle, c_white, 1
	);
	
	ds_list_add(playerListInfoPanelElements,
		playerListTitle
	);
	
	// PLAYER LIST
	var emptyPlayerList = ds_list_create();
	var playerListSize = new Size(windowSize.w, windowSize.h - infoPanelSize.h);
	var playerListPosition = new Vector2(0, infoPanelSize.h);
	var onClickPlayerListInspect = function()
	{
		show_message("Hello!");
	}
	var playerList = new WindowCollectionList(
		"PlayerList",
		playerListPosition,
		playerListSize,
		undefined, emptyPlayerList,
		ListDrawPlayerList, true, onClickPlayerListInspect
	);
	
	// LOADING ICON
	var playerListLoading = new WindowLoading(
		"PlayerListLoading",
		playerListPosition,
		playerListSize,
		undefined
	);
	playerListLoading.isVisible = false;
	
	ds_list_add(playerListElements,
		playerListTitle,
		playerList,
		playerListLoading,
		playerListInfoPanel
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// REQUEST PLAYER LIST
		if (global.MultiplayerMode)
		{
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_PLAYER_LIST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined,
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				// SHOW PLAYER LIST LOADING ICON
				var playerListWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.PlayerList);
				if (!is_undefined(playerListWindow))
				{
					var playerListLoadingElement = playerListWindow.GetChildElementById("PlayerListLoading");
					if (!is_undefined(playerListLoadingElement))
					{
						playerListLoadingElement.isVisible = true;
					}
				}
			}
		}
	}
	playerListWindow.OnOpen = overrideOnOpen;
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// CLEAR IN-FLIGHT PLAYER LIST REQUESTS
		if (global.MultiplayerMode)
		{
			global.NetworkPacketTrackerRef.ClearInFlightPacketsByMessageType(MESSAGE_TYPE.REQUEST_PLAYER_LIST);
		}
	}
	playerListWindow.OnClose = overrideOnClose;
	
	playerListWindow.AddChildElements(playerListElements);
	playerListInfoPanel.AddChildElements(playerListInfoPanelElements);
	return playerListWindow;
}