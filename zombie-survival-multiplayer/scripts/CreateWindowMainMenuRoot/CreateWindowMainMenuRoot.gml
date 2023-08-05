function CreateWindowMainMenuRoot(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(undefined, 0);
	var mainMenuWindow = new GameWindow(
		GAME_WINDOW.MainMenuRoot,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	// MENU TITLE
	var mainMenuTitlePanelSize = new Size(windowSize.w, 90);
	var mainMenuTitlePanel = new WindowPanel(
		"MainMenuTitlePanel",
		new Vector2(0, 50),
		mainMenuTitlePanelSize, #121212
	);
	
	var mainMenuTitle = new WindowText(
		"MainMenuTitle",
		new Vector2(mainMenuTitlePanelSize.w * 0.5, mainMenuTitlePanelSize.h * 0.5),
		undefined, undefined,
		"World Against Us (Multiplayer)", font_huge, fa_center, fa_middle, c_white, 1
	);
	
	var mainMenuButtons = ds_list_create();
	ds_list_add(mainMenuButtons,
		{ title: "Singleplayer", onClick: OnClickMenuSingleplayer, metadata: undefined },
		{ title: "Multiplayer", onClick: OnClickMenuMultiplayer, metadata: undefined },
		{ title: "Quit", onClick: OnClickMenuQuit, metadata: undefined }
	);

	var mainButtonStyle = new ButtonStyle(
		new Size(400, 100), 20,
		c_white, c_ltgray,
		fa_center, fa_middle,
		c_black, c_black,
		font_large,
		fa_center, fa_middle 
	);
	
	var mainMenuButtonMenu = new WindowButtonMenu(
		"MainMenuButtonMenu",
		new Vector2(600, 470),
		undefined, undefined, mainMenuButtons, mainButtonStyle
	);
	
	var mainMenuTitlePanelElements = ds_list_create();
	ds_list_add(mainMenuTitlePanelElements,
		mainMenuTitle
	);
	
	var mainMenuElements = ds_list_create();
	ds_list_add(mainMenuElements, 
		mainMenuTitlePanel,
		mainMenuButtonMenu
	);
	
	mainMenuWindow.AddChildElements(mainMenuElements);
	mainMenuTitlePanel.AddChildElements(mainMenuTitlePanelElements);
	return mainMenuWindow;
}