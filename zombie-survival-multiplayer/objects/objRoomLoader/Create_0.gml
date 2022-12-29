depth = -9999;

var systemTimeStart = string(current_hour) + ":" + string(current_minute) + "." + string(current_second);
show_debug_message("");
show_debug_message(string("------------ Game Launching {0} ------------", systemTimeStart));

controllers = [
	// LAUNCH ROOM
	new GameController(objDisplay, [], []),
	new GameController(objGameWindow, [], []),
	
	// MAIN MENU
	new GameController(objGlobals, [], [roomLaunch]),
	new GameController(objNetwork, [], [roomLaunch]),
	new GameController(objGameSave, [], [roomLaunch]),
	
	new GameController(objGUI, [], [roomLaunch]),
	new GameController(objMouse, [], [roomLaunch]),
	
	new GameController(objMainMenu, [roomMainMenu], [roomLaunch]),
	
	// GAME
	new GameController(objCamera, [], [roomMainMenu, roomLaunch]),
	new GameController(objHud, [], [roomMainMenu, roomLaunch]),
	new GameController(objMessageLog, [], [roomMainMenu, roomLaunch]),
	new GameController(objNotification, [], [roomMainMenu, roomLaunch]),
	
	new GameController(objDatabase, [], [roomMainMenu, roomLaunch]),
	new GameController(objInventory, [], [roomMainMenu, roomLaunch]),
	new GameController(objTempInventory, [], [roomMainMenu, roomLaunch]),
	new GameController(objJournal, [], [roomMainMenu, roomLaunch]),
	new GameController(objQuest, [], [roomMainMenu, roomLaunch]),
	
	new GameController(objGridPath, [], [roomMainMenu, roomLaunch])
];

// ROOM FADE-IN EFFECT
roomFadeAlphaStart = 1;
roomFadeAlpha = roomFadeAlphaStart;
roomFadeAlphaStep = 0.015;