function CreateWindowWorldMap(_gameWindowId, _zIndex)
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
		"World Map",
		font_default, fa_left, fa_middle, c_white, 1
	);
	
	ds_list_add(mapInfoPanelElements,
		mapTitle
	);
	
	// INSTANCE LIST
	var emptyInstanceList = ds_list_create();
	var instanceListSize = new Size(300, windowSize.h - infoPanelSize.h - global.ObjHud.hudHeight - 50);
	var instanceListPosition = new Vector2(10, infoPanelSize.h + 40);
	var instanceList = new WindowCollectionList(
		"InstanceList",
		instanceListPosition,
		instanceListSize,
		#555973, emptyInstanceList,
		ListDrawAvailableInstance, true, OnClickWorldMapAvailableInstance
	);
	
	// INSTANCE LIST TITLE
	var instanceListTitlePosition = new Vector2(instanceListPosition.X + (instanceListSize.w * 0.5), infoPanelSize.h + 10);
	var instanceListTitle = new WindowText(
		"InstanceListTitle",
		instanceListTitlePosition,
		undefined, undefined,
		"--Available instances--", font_default, fa_center, fa_top, c_white, 1
	);
	
	// LOADING ICON
	var instanceListLoading = new WindowLoading(
		"InstanceListLoading",
		instanceListPosition,
		instanceListSize,
		undefined
	);
	instanceListLoading.isVisible = false;
	
	// MAP BACKGROUND IMAGE
	var mapBackgroundImageSize = new Size(windowSize.w - instanceListSize.w - 30, windowSize.h - infoPanelSize.h - global.ObjHud.hudHeight);
	var mapBackgroundImage = new WindowImage(
		"MapBackgroundImage",
		new Vector2(instanceListSize.w + 20, infoPanelSize.h),
		mapBackgroundImageSize, undefined, sprWorldMap, 0, 1, 0
	);
	
	// FAST TRAVEL BUTTONS
	var buttonSize = new Size(150, 100);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#85774d, #615636,
		fa_left, fa_top,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	
	// WORLD MAP LOCATION ICON
	var mapLocationIconSize = new Size(150, 98);
	var mapLocationIconOffset = 20;
	
	var buttonPositionCamp = new Vector2(600, 260);
	var campWorldMapLocationData = global.WorldMapLocationData[? ROOM_INDEX_CAMP];
	var fastTravelCampButton = new WindowButton(
		"FastTravelCampButton",
		buttonPositionCamp, buttonSize,
		buttonStyle.button_background_color, campWorldMapLocationData.name, buttonStyle, undefined,
		campWorldMapLocationData
	);
	fastTravelCampButton.isActive = false;
	
	// CAMP MAP ICON
	var mapLocationIconCamp = new WindowImage(
		"MapLocationIconCamp",
		new Vector2(
			buttonPositionCamp.X,
			buttonPositionCamp.Y - mapLocationIconSize.h - mapLocationIconOffset,
		),
		mapLocationIconSize,
		undefined, sprMapIconCamp,
		0, 1, 0
	);
	
	var buttonPositionTown = new Vector2(1300, 310);
	var townWorldMapLocationData = global.WorldMapLocationData[? ROOM_INDEX_TOWN];
	var fastTravelTownButton = new WindowButton(
		"FastTravelTownButton",
		buttonPositionTown, buttonSize,
		buttonStyle.button_background_color, townWorldMapLocationData.name, buttonStyle, OnClickWorldMapFastTravel,
		townWorldMapLocationData
	);
	
	// TOWN MAP ICON
	var mapLocationIconTown = new WindowImage(
		"MapLocationIconTown",
		new Vector2(
			buttonPositionTown.X,
			buttonPositionTown.Y - mapLocationIconSize.h - mapLocationIconOffset,
		),
		mapLocationIconSize,
		undefined, sprMapIconTown,
		0, 1, 0
	);
	
	var buttonPositionForest = new Vector2(800, 760);
	var forestWorldMapLocationData = global.WorldMapLocationData[? ROOM_INDEX_FOREST];
	var fastTravelForestButton = new WindowButton(
		"FastTravelForestButton",
		buttonPositionForest, buttonSize,
		buttonStyle.button_background_color, forestWorldMapLocationData.name, buttonStyle, OnClickWorldMapFastTravel,
		forestWorldMapLocationData
	);
	
	// FOREST MAP ICON
	var mapLocationIconForest = new WindowImage(
		"MapLocationIconForest",
		new Vector2(
			buttonPositionForest.X,
			buttonPositionForest.Y - mapLocationIconSize.h - mapLocationIconOffset,
		),
		mapLocationIconSize,
		undefined, sprMapIconForest,
		0, 1, 0
	);
	
	ds_list_add(mapElements,
		mapBackgroundImage,
		// Render after map
		fastTravelCampButton,
		mapLocationIconCamp,
		fastTravelTownButton,
		mapLocationIconTown,
		fastTravelForestButton,
		mapLocationIconForest,
		instanceListTitle,
		instanceList,
		instanceListLoading,
		mapInfoPanel
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// REQUEST INSTANCE LIST
		if (global.MultiplayerMode)
		{
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_INSTANCE_LIST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined, PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				// SHOW INSTANCE LIST LOADING ICON
				var worldMapWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.WorldMap);
				if (!is_undefined(worldMapWindow))
				{
					var instanceListLoadingElement = worldMapWindow.GetChildElementById("InstanceListLoading");
					if (!is_undefined(instanceListLoadingElement))
					{
						instanceListLoadingElement.isVisible = true;
					}
				}
			} else {
				show_debug_message("Failed to request instance list");
			}
		}
	}
	mapWindow.OnOpen = overrideOnOpen;
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// CLEAR IN-FLIGHT INSTANCE LIST REQUESTS
		if (global.MultiplayerMode)
		{
			global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.REQUEST_INSTANCE_LIST);
		}
	}
	mapWindow.OnClose = overrideOnClose;
	
	mapWindow.AddChildElements(mapElements);
	mapInfoPanel.AddChildElements(mapInfoPanelElements);
	return mapWindow;
}