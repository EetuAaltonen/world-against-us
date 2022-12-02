if (initMainMenu)
{
	initMainMenu = false;
	
	var mainMenuWindow = new GameWindow(
		"MainMenuWindow",
		new Vector2(0, 0),
		new Size(1920, 1080),
		new GameWindowStyle(#486a7d, 1),
		0
	);
	
	var mainMenuElements = ds_list_create();
	// MENU TITLE
	var mainMenuTitle = new WindowText(
		"MainMenuTitle",
		new Vector2(global.GUIW * 0.5, 50),
		undefined, undefined,
		"Menu", font_large, fa_center, fa_middle, c_dkgray, 1
	);
	ds_list_add(mainMenuElements, mainMenuTitle);
	
	var mainMenuButtonMenu = new WindowButtonMenu(
		"MainMenuButtonMenu",
		new Vector2(mainMenuWindow.size.w * 0.5, mainMenuWindow.size.h * 0.4),
		undefined, undefined, mainMenuButtons, mainButtonStyle
	);
	ds_list_add(mainMenuElements, mainMenuButtonMenu);
	
	mainMenuWindow.AddChildElements(mainMenuElements);
	ds_list_add(global.ObjWindowHandler.gameWindows, mainMenuWindow);
}