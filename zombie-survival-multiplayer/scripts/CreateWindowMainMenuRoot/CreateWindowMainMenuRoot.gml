function CreateWindowMainMenuRoot(_zIndex)
{
	var mainMenuWindow = new GameWindow(
		GAME_WINDOW.MainMenuRoot,
		new Vector2(0, 0),
		new Size(1920, 1080),
		new GameWindowStyle(#486a7d, 1),
		_zIndex
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
	
	var mainMenuButtons = ds_list_create();
	ds_list_add(mainMenuButtons,
		{ title: "Singleplayer", onClick: OnClickMenuSingleplayer },
		{ title: "Multiplayer", onClick: OnClickMenuMultiplayer },
		{ title: "Quit", onClick: OnClickMenuQuit }
	);

	var mainButtonStyle = new ButtonStyle(
		new Size(200, 50),
		#6f4082, #9365a6,
		font_default, 25, fa_middle, fa_center
	);
	
	var mainMenuButtonMenu = new WindowButtonMenu(
		"MainMenuButtonMenu",
		new Vector2(mainMenuWindow.size.w * 0.5, mainMenuWindow.size.h * 0.4),
		undefined, undefined, mainMenuButtons, mainButtonStyle
	);
	ds_list_add(mainMenuElements, mainMenuButtonMenu);
	
	mainMenuWindow.AddChildElements(mainMenuElements);
	return mainMenuWindow;
}