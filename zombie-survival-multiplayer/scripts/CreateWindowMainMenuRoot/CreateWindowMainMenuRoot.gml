function CreateWindowMainMenuRoot(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(undefined, 0);
	var mainMenuWindow = new GameWindow(
		GAME_WINDOW.MainMenuRoot,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var mainMenuElements = ds_list_create();
	// MENU TITLE
	var mainMenuTitle = new WindowText(
		"MainMenuTitle",
		new Vector2(windowSize.w * 0.5, 100),
		undefined, undefined,
		"Zombie Survival (Multiplayer)", font_huge, fa_center, fa_middle, c_white, 1
	);
	ds_list_add(mainMenuElements, mainMenuTitle);
	
	var mainMenuButtons = ds_list_create();
	ds_list_add(mainMenuButtons,
		{ title: "Singleplayer", onClick: OnClickMenuSingleplayer },
		{ title: "Multiplayer", onClick: OnClickMenuMultiplayer },
		{ title: "Quit", onClick: OnClickMenuQuit }
	);

	var mainButtonStyle = new ButtonStyle(
		new Size(400, 100),
		c_white, c_ltgray,
		font_large, 20, fa_middle, fa_center
	);
	
	var mainMenuButtonMenu = new WindowButtonMenu(
		"MainMenuButtonMenu",
		new Vector2(400, 450),
		undefined, undefined, mainMenuButtons, mainButtonStyle
	);
	ds_list_add(mainMenuElements, mainMenuButtonMenu);
	
	mainMenuWindow.AddChildElements(mainMenuElements);
	return mainMenuWindow;
}