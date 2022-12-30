function CreateWindowEscMenu(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var mainMenuWindow = new GameWindow(
		GAME_WINDOW.EscMenu,
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
		{ title: "Continue", onClick: OnClickEscMenuContinue },
		{ title: "Save game", onClick: OnClickEscMenuSave },
		{ title: "Reset save", onClick: OnClickEscMenuReset },
		{ title: "Main menu", onClick: OnClickEscMenuQuit }
	);

	var menuButtonStyle = new ButtonStyle(
		new Size(200, 50),
		#6f4082, #9365a6,
		font_default, 25, fa_middle, fa_center
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