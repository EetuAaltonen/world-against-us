if (initMainMenu)
{
	initMainMenu = false;
	
	ds_list_add(
		global.ObjWindowHandler.gameWindows,
		new MainMenuWindow(
			"MainMenuWindow",
			GAME_WINDOW_TYPE.MainMenu,
			new Vector2(0, 0),
			new Size(global.GUIW, global.GUIH),
			0, menuButtons
		)
	);
}