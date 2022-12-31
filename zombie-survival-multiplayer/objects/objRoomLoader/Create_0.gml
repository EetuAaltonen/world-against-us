depth = -9000;

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
	new GameController(objMouse, [], [roomLaunch], "Controllers_All_Front"),
	new GameController(objMessageLog, [], [roomLaunch], "Controllers_Front"),
	
	new GameController(objMainMenu, [roomMainMenu], [roomLaunch]),
	
	// GAME
	new GameController(objCamera, [], [roomMainMenu, roomLaunch]),
	new GameController(objHud, [], [roomMainMenu, roomLaunch], "Controllers_Behind"),
	new GameController(objNotification, [], [roomMainMenu, roomLaunch], "Controllers_Front"),
	
	new GameController(objDatabase, [], [roomMainMenu, roomLaunch]),
	new GameController(objInventory, [], [roomMainMenu, roomLaunch]),
	new GameController(objTempInventory, [], [roomMainMenu, roomLaunch]),
	new GameController(objJournal, [], [roomMainMenu, roomLaunch]),
	new GameController(objQuest, [], [roomMainMenu, roomLaunch]),
	
	new GameController(objGridPath, [], [roomMainMenu, roomLaunch])
];

controllerLayers = ds_map_create();
ds_map_add(controllerLayers, "Controllers", depth);
ds_map_add(controllerLayers, "Controllers_Behind", depth + 1);
ds_map_add(controllerLayers, "Controllers_Front", depth - 1);
ds_map_add(controllerLayers, "Controllers_All_Front", depth - 2);

// ROOM FADE-IN EFFECT
roomFadeAlphaStart = 1;
roomFadeAlpha = roomFadeAlphaStart;
roomFadeAlphaStep = 0.015;