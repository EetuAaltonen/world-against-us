depth = -9000;

var systemTimeStart = string(current_hour) + ":" + string(current_minute) + "." + string(current_second);
show_debug_message("");
show_debug_message(string("------------ Game Launching {0} ------------", systemTimeStart));

controllers = [
	// LAUNCH ROOM
	new GameController(objDisplay, [], []),
	new GameController(objGameWindow, [], []),
	
	// CAMERA
	new GameController(objCamera, [], [roomLaunch]),
	
	// MAIN MENU
	new GameController(objGlobals, [], [roomLaunch]),
	new GameController(objNetwork, [], [roomLaunch]),
	
	new GameController(objGUI, [], [roomLaunch]),
	new GameController(objMouse, [], [roomLaunch], "Controllers_All_Front"),
	new GameController(objMessageLog, [], [roomLaunch], "Controllers_Front"),
	
	new GameController(objMainMenu, [roomMainMenu], [roomLaunch]),
	
	// GAME
	new GameController(objHud, [], [roomLaunch, roomMainMenu, roomLoadSave], "Controllers_Behind"),
	new GameController(objNotification, [], [roomLaunch, roomMainMenu], "Controllers_Front"),
	
	new GameController(objDatabase, [], [roomLaunch, roomMainMenu]),
	new GameController(objInventory, [], [roomLaunch, roomMainMenu]),
	new GameController(objTempInventory, [], [roomLaunch, roomMainMenu, roomLoadSave]),
	new GameController(objJournal, [], [roomLaunch, roomMainMenu]),
	new GameController(objQuest, [], [roomLaunch, roomMainMenu]),
	
	new GameController(objMap, [], [roomLaunch, roomMainMenu], "Controllers_Behind"),

	
	new GameController(objInstanceHighlighter, [], [roomLaunch, roomMainMenu, roomLoadSave], "HighlightedInstances"),
	
	new GameController(objGridPath, [], [roomLaunch, roomMainMenu, roomLoadSave]),
	
	// LOAD THE GAME SAVE OBJECT LAST
	// TO SET THE WORLD STATE AFTER EVERYTHING IS LOADED
	new GameController(objGameSave, [], [roomLaunch]),
];

controllerLayers = ds_map_create();
ds_map_add(controllerLayers, "Controllers", depth);
ds_map_add(controllerLayers, "Controllers_Behind", depth + 1);
ds_map_add(controllerLayers, "Controllers_Front", depth - 1);
ds_map_add(controllerLayers, "Controllers_All_Front", depth - 2);
ds_map_add(controllerLayers, "HighlightedInstances", depth); // DEPTH CHANGED AT RUNTIME

// ROOM FADE-IN EFFECT
roomFadeAlphaStart = 1;
roomFadeAlpha = roomFadeAlphaStart;
roomFadeAlphaStep = 0.015;