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
	var mapPanelSize = new Size(windowSize.w - 100, windowSize.h - 140);
	
	var worldMapElement = new WindowWorldMap(
		"worldMapElement",
		new Vector2(windowSize.w * 0.5 - (mapPanelSize.w * 0.5), 20),
		mapPanelSize, undefined
	);
	
	ds_list_add(mapElements,
		worldMapElement
	);
	
	var mapPanelElements = ds_list_create();
	// PANEL TITLE
	var mapPanelTitle = new WindowText(
		"mapPanelTitle",
		new Vector2(mapPanelSize.w * 0.5, 50),
		undefined, undefined,
		"Map", font_large, fa_center, fa_middle, c_black, 1
	);
	
	ds_list_add(mapPanelElements,
		mapPanelTitle
	);
	
	mapWindow.AddChildElements(mapElements);
	worldMapElement.AddChildElements(mapPanelElements);
	return mapWindow;
}