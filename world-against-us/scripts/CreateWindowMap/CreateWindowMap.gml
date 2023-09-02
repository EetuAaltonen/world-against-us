function CreateWindowMap(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var mapWindow = new GameWindow(
		GAME_WINDOW.Map,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var mapElements = ds_list_create();
	

	var mapSize = new Size(windowSize.w - 100, windowSize.h - 140);
	var mapElement = new WindowMap(
		"MapElement",
		new Vector2(windowSize.w * 0.5 - (mapSize.w * 0.5), 20),
		mapSize, undefined
	);
	
	var mapInfoPanelElements = ds_list_create();
	
	// INFO PANEL
	var mapInfoPanel = new WindowPanel(
		"MapTitle",
		new Vector2(0, 0),
		new Size(windowSize.w, 40),
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
	
	
	ds_list_add(mapElements,
		mapElement,
		mapInfoPanel // Render after map
	);
	
	mapWindow.AddChildElements(mapElements);
	mapInfoPanel.AddChildElements(mapInfoPanelElements);
	return mapWindow;
}