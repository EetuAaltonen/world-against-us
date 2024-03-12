function CreateWindowOperationsCenter(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var mapWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var mapElements = ds_list_create();
	var mapInfoPanelElements = ds_list_create();
	
	// INFO PANEL
	var infoPanelSize = new Size(windowSize.w, 40);
	var mapInfoPanel = new WindowPanel(
		"MapInfoPanel",
		new Vector2(0, 0),
		infoPanelSize,
		c_black
	);
	
	// INFO PANEL TITLE
	var mapTitle = new WindowText(
		"MapTitle",
		new Vector2(10, 20),
		undefined, undefined,
		string("Map: {0}", room_get_name(room)),
		font_default, fa_left, fa_middle, c_white, 1
	);
	
	ds_list_add(mapInfoPanelElements,
		mapTitle
	);

	// MAP ELEMENT
	var mapSize = new Size(windowSize.w - 100, windowSize.h - global.ObjHud.hudHeight - infoPanelSize.h);
	var mapElement = new WindowMap(
		"MapElement",
		new Vector2(windowSize.w * 0.5 - (mapSize.w * 0.5), infoPanelSize.h),
		mapSize, undefined
	);
	
	// MAP INSTANCE LIST BUTTON
	var buttonSize = new Size(50, 50);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#db650f, #9e4d11,
		fa_left, fa_top,
		c_black, c_black,
		font_tiny_bold,
		fa_right, fa_middle
	);
	var buttonPosition = new Vector2(0, (windowSize.h * 0.5) - (buttonSize.h * 0.5));
	var mapInstanceListButton = new WindowButton(
		"MapInstanceListButton",
		buttonPosition, buttonSize,
		buttonStyle.button_background_color,
		"Scout-> ",
		buttonStyle,
		OnClickOperationsScoutList, undefined
	);
	
	ds_list_add(mapElements,
		mapElement,
		// Render after map
		mapInfoPanel,
		mapInstanceListButton,
	);
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		if (global.MultiplayerMode)
		{
			// REQUEST OPERATIONS END SCOURING STREAM
			if (!is_undefined(global.MapDataHandlerRef.active_operations_scout_stream))
			{
				var targetScoutRegion = global.MapDataHandlerRef.target_scout_region;
				if (!is_undefined(targetScoutRegion))
				{
					var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM);
					var networkPacket = new NetworkPacket(
						networkPacketHeader,
						targetScoutRegion,
						PACKET_PRIORITY.DEFAULT,
						AckTimeoutFuncResend
					);
					if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
					{
						show_debug_message("Unable to queue MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM");
					}
				}
				
				// RESET ACTIVE OPERATIONS SCOUT STREAM AFTER REQUEST
				global.MapDataHandlerRef.ResetActiveOperationsScoutStream();
			}
			// CLEAR AND CANCEL OPERATIONS SCOUTING STREAM MESSAGES
			global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM);
			global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.SCOUTING_DRONE_DATA_POSITION);
		}
		
		// RESET MAP DATA
		global.MapDataHandlerRef.ResetMapData();
	}
	mapWindow.OnClose = overrideOnClose;
	
	mapWindow.AddChildElements(mapElements);
	mapInfoPanel.AddChildElements(mapInfoPanelElements);
	return mapWindow;
}