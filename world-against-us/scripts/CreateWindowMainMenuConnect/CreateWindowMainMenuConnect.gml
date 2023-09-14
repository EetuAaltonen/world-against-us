function CreateWindowMainMenuConnect(_gameWindowId, _zIndex, _address, _port)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(#217fb5, 1);
	var multiplayerConnectWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);	
	
	var multiplayerConnectElements = ds_list_create();
	// CONNECTING TITLE
	ds_list_add(multiplayerConnectElements,
		new WindowText(
			"MultiplayerConnectTitle",
			new Vector2(windowSize.w * 0.5, windowSize.h * 0.5),
			undefined, undefined,
			string("Connecting {0}:{1}...", _address, _port),
			font_default, fa_center, fa_middle, c_black, 1
		)
	);
	
	multiplayerConnectWindow.AddChildElements(multiplayerConnectElements);
	return multiplayerConnectWindow;
}