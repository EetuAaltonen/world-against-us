function CreateWindowWorldMapFastTravelQueue(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(#7d9ac7, 1);
	var fastTravelQueueWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);	
	
	var fastTravelQueueElements = ds_list_create();
	
	// FAST TRAVEL TITLE
	var fastTravelTitle = new WindowText(
		"ConnectTitle",
		new Vector2(windowSize.w * 0.5, 500),
		undefined, undefined,
		"Fast travel in queue...",
		font_default, fa_center, fa_middle, c_black, 1
	);
	
	ds_list_add(fastTravelQueueElements,
		fastTravelTitle
	);
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// CLEAR IN-FLIGHT FAST TRAVEL REQUESTS
		if (global.MultiplayerMode)
		{
			global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.REQUEST_FAST_TRAVEL);
		}
	}
	fastTravelQueueWindow.OnClose = overrideOnClose;
	
	
	fastTravelQueueWindow.AddChildElements(fastTravelQueueElements);
	return fastTravelQueueWindow;
}