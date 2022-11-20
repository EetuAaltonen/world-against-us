menuButtons = ds_list_create();
initMainMenu = true;

var singleplayerFunction = function()
{
	show_message("SINGLEPLAYER");
	return;
}
ds_list_add(menuButtons,
	new MainMenuButton(
		"Singleplayer",
		sprGUIGrid,
		singleplayerFunction
	)
);
var multiplayerFunction = function()
{
	ds_list_add(
		global.ObjWindowHandler.gameWindows,
		new MultiplayerOptionWindow(
			"MultiplayerOptionWindow",
			GAME_WINDOW_TYPE.MultiplayerOptions,
			new Vector2(global.GUIW * 0.2, global.GUIH * 0.2),
			new Size(global.GUIW * 0.6, global.GUIH * 0.6), -1
		)
	);
}
ds_list_add(menuButtons,
	new MainMenuButton(
		"Multiplayer",
		sprGUIGrid,
		multiplayerFunction
	)
);
var exitFunction = function()
{
	game_end();
}
ds_list_add(menuButtons,
	new MainMenuButton(
		"Exit",
		sprGUIGrid,
		exitFunction
	)
);