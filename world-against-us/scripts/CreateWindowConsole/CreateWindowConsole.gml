function CreateWindowConsole(_gameWindowId, _zIndex, _consoleMessages)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var consoleWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var consoleElements = ds_list_create();
	
	var consoleTitlePosition = new Vector2(10, 10);
	var consoleTitleElement = new WindowText(
		"ConsoleTitle",
		consoleTitlePosition,
		undefined, undefined,
		"Console", font_default, fa_left, fa_top, c_white, 1
	);
	
	var consoleLogPosition = new Vector2(0, 40);
	var consoleLogSize = new Size(windowSize.w, floor(windowSize.h * 0.75) - consoleLogPosition.Y);
	var consoleListElementStyle = new WindowElementStyle(
		new Size(consoleLogSize.w, 12), 0,
		fa_left, fa_top,
		undefined, undefined,
		0, undefined,
		undefined, undefined,
		font_console,
		fa_left, fa_middle
	);
	var consoleLogElement = new WindowCollectionListExt(
		"ConsoleLogList",
		consoleLogPosition,
		consoleLogSize, undefined,
		_consoleMessages,
		ListDrawConsoleLog,
		consoleListElementStyle,
		false, undefined
	);
	
	ds_list_add(consoleElements,
		consoleTitleElement,
		consoleLogElement
	);
	
	consoleWindow.AddChildElements(consoleElements);
	return consoleWindow;
}