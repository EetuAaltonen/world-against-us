function CreateWindowOperationsScoutList(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var scoutListWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var scoutListElements = ds_list_create();
	
	// SCOUT LIST
	var emptyScoutList = ds_list_create();
	var scoutListSize = new Size(300, windowSize.h - global.ObjHud.hudHeight - 50);
	var scoutListPosition = new Vector2(10, 40);
	var scoutList = new WindowCollectionList(
		"ScoutList",
		scoutListPosition,
		scoutListSize,
		#555973, emptyScoutList,
		ListDrawAvailableScoutInstance, true, onClickOperationsScoutListInstance
	);
	
	// SCOUT LIST TITLE
	var scoutListTitlePosition = new Vector2(scoutListPosition.X + (scoutListSize.w * 0.5), 10);
	var scoutListTitle = new WindowText(
		"ScoutListTitle",
		scoutListTitlePosition,
		undefined, undefined,
		"--Available scouting--", font_default, fa_center, fa_top, c_white, 1
	);
	
	// LOADING ICON
	var scoutListLoading = new WindowLoading(
		"ScoutListLoading",
		scoutListPosition,
		scoutListSize,
		undefined
	);
	scoutListLoading.isVisible = false;
	
	ds_list_add(scoutListElements,
		scoutListTitle,
		scoutList,
		scoutListLoading
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// REQUEST SCOUT LIST
		if (global.MultiplayerMode)
		{
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_SCOUT_LIST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined, PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				// SHOW SCOUT LIST LOADING ICON
				var scoutListWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenterScoutList);
				if (!is_undefined(scoutListWindow))
				{
					var scoutListLoadingElement = scoutListWindow.GetChildElementById("ScoutListLoading");
					if (!is_undefined(scoutListLoadingElement))
					{
						scoutListLoadingElement.isVisible = true;
					}
				}
			} else {
				// TODO: Generic error handling
				show_debug_message("Failed to request scout list");
			}
		}
	}
	scoutListWindow.OnOpen = overrideOnOpen;
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		if (global.MultiplayerMode)
		{
			// CLEAR IN-FLIGHT REQUEST SCOUT LIST MESSAGES
			global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.REQUEST_SCOUT_LIST);
		}
	}
	scoutListWindow.OnClose = overrideOnClose;
	
	scoutListWindow.AddChildElements(scoutListElements);
	return scoutListWindow;
}