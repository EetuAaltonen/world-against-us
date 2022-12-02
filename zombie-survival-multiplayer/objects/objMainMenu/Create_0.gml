mainMenuButtons = ds_list_create();
ds_list_add(mainMenuButtons,
	{ title: "Singleplayer", onClick: OnClickMenuSingleplayer },
	{ title: "Multiplayer", onClick: OnClickMenuMultiplayer },
	{ title: "Quit", onClick: OnClickMenuQuit }
);
initMainMenu = true;

// MAIN MENU BUTTONS
mainButtonStyle = {
	position: new Vector2(0, 300),
	size: new Size(200, 50),
	color: #7a2c99,
	margin: 25,
};