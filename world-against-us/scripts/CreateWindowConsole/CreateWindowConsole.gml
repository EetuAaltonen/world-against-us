function CreateWindowConsole(_gameWindowId, _zIndex, _consoleMessages)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var mapWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var consoleElements = ds_list_create();
	var consoleLogElement = new WindowCollectionList(
		"consoleLogList",
		new Vector2(0, 0),
		windowSize, undefined,
		_consoleMessages,
		ListDrawConsoleLog,
		false, undefined
	);
	
	ds_list_add(consoleElements,
		consoleLogElement
	);
	
	mapWindow.AddChildElements(consoleElements);
	return mapWindow;
}