function CreateWindowEscMenu(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var mainMenuWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var escMenuElements = ds_list_create();
	// MENU TITLE
	var escMenuTitle = new WindowText(
		"EscMenuTitle",
		new Vector2(windowSize.w * 0.5, 50),
		undefined, undefined,
		"Game Menu", font_large, fa_center, fa_middle, c_white, 1
	);
	ds_list_add(escMenuElements, escMenuTitle);
	
	var escMenuButtons = ds_list_create();
	ds_list_add(escMenuButtons,
		{ title: "Continue", onClick: OnClickEscMenuContinue, metadata: undefined }
	);
	
	if (room != roomLoadResources)
	{
		if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.OFFLINE)
		{
			ds_list_add(escMenuButtons,
				{ title: "Save game", onClick: OnClickEscMenuSave, metadata: undefined },
				{ title: "Reset save", onClick: OnClickEscMenuReset, metadata: undefined }
			);
		}
	}
	
	ds_list_add(escMenuButtons,
		{ title: "Main menu", onClick: OnClickEscMenuQuit, metadata: undefined }
	);

	var menuButtonStyle = new ButtonStyle(
		new Size(200, 50), 25,
		#6f4082, #9365a6,
		fa_center, fa_middle,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	
	var escMenuButtonMenu = new WindowButtonMenu(
		"EscMenuButtonMenu",
		new Vector2(mainMenuWindow.size.w * 0.5, mainMenuWindow.size.h * 0.4),
		undefined, undefined, escMenuButtons, menuButtonStyle
	);
	ds_list_add(escMenuElements, escMenuButtonMenu);
	
	mainMenuWindow.AddChildElements(escMenuElements);
	return mainMenuWindow;
}