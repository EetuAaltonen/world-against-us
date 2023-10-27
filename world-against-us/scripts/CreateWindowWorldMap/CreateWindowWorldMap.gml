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
		"MapTitle",
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
	var instances = ds_list_create();
	ds_list_add(instances,
		"Test1",
		"Test2",
		"Test3",
		"Test4"
	);
	var testFunction = function()
	{
		show_message("Hello World!");
	}
	var instanceListSize = new Size(300, windowSize.h - infoPanelSize.h - global.ObjHud.hudHeight - 50);
	var instanceListPosition = new Vector2(10, infoPanelSize.h + 40);
	var instanceList = new WindowCollectionList(
		"InstanceList",
		instanceListPosition,
		instanceListSize,
		#555973, instances,
		ListDrawSaveFile, true, testFunction
	);
	
	// INSTANCE LIST TITLE
	var instanceListTitlePosition = new Vector2(instanceListPosition.X + (instanceListSize.w * 0.5), infoPanelSize.h + 10);
	var instanceListTitle = new WindowText(
		"InstanceListTitle",
		instanceListTitlePosition,
		undefined, undefined,
		"--Available instances--", font_default, fa_center, fa_top, c_white, 1
	);
	
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
		#48a630, #2c8017,
		fa_left, fa_top,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	
	var buttonPositionCamp = new Vector2(703, 425);
	var fastTravelCampButton = new WindowButton(
		"FastTravelCampButton",
		buttonPositionCamp, buttonSize,
		buttonStyle.button_background_color, "Camp", buttonStyle, testFunction
	);
	
	var buttonPositionTown = new Vector2(1388, 408);
	var fastTravelTownButton = new WindowButton(
		"FastTravelTownButton",
		buttonPositionTown, buttonSize,
		buttonStyle.button_background_color, "Town", buttonStyle, testFunction
	);
	
	var buttonPositionForest = new Vector2(1038, 753);
	var fastTravelForestButton = new WindowButton(
		"FastTravelForestButton",
		buttonPositionForest, buttonSize,
		buttonStyle.button_background_color, "Forest", buttonStyle, testFunction
	);
	
	ds_list_add(mapElements,
		mapBackgroundImage,
		// Render after map
		fastTravelCampButton,
		fastTravelTownButton,
		fastTravelForestButton,
		instanceListTitle,
		instanceList,
		mapInfoPanel
	);
	
	mapWindow.AddChildElements(mapElements);
	mapInfoPanel.AddChildElements(mapInfoPanelElements);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// TRIGGER MAP UPDATE
		global.MapDataHandlerRef.is_dynamic_data_updating = true;
		global.MapDataHandlerRef.map_update_timer.TriggerTimer();
	}
	mapWindow.OnOpen = overrideOnOpen;
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// SUSPEND MAP UPDATE
		global.MapDataHandlerRef.is_dynamic_data_updating = true;
	}
	mapWindow.OnClose = overrideOnClose;
	return mapWindow;
}