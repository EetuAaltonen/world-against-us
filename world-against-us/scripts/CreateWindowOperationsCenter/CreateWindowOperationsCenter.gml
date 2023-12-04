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
	mapElement.SetMapLocation(ROOM_INDEX_TOWN);
	
	ds_list_add(mapElements,
		mapElement,
		mapInfoPanel // Render after map
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// INIT SCOUTING DRONE
		global.MapDataHandlerRef.scouting_drone = new InstanceObject(sprDrone, objDrone, new Vector2(0, 0));
		var operationsCenterWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenter);
		if (!is_undefined(operationsCenterWindow))
		{
			var mapElement = operationsCenterWindow.GetChildElementById("MapElement");
			if (!is_undefined(mapElement))
			{
				mapElement.UpdateFollowTarget();
			}
		}
		// TRIGGER MAP UPDATE
		global.MapDataHandlerRef.is_dynamic_data_updating = true;
		global.MapDataHandlerRef.map_update_timer.TriggerTimer();
	}
	mapWindow.OnOpen = overrideOnOpen;
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// REMOVE SCOUTING DRONE
		global.MapDataHandlerRef.scouting_drone = undefined;
		// SUSPEND MAP UPDATE
		global.MapDataHandlerRef.is_dynamic_data_updating = true;
	}
	mapWindow.OnClose = overrideOnClose;
	
	mapWindow.AddChildElements(mapElements);
	mapInfoPanel.AddChildElements(mapInfoPanelElements);
	return mapWindow;
}