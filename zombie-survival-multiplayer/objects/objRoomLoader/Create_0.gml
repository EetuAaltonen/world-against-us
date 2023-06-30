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
	new GameController(objMouse, [], [roomLaunch], LAYER_CONTROLLERS_ALL_FRONT),
	new GameController(objMessageLog, [], [roomLaunch], LAYER_CONTROLLERS_FRONT),
	
	new GameController(objMainMenu, [roomMainMenu], [roomLaunch]),
	
	// GAME
	new GameController(objHud, [], [roomLaunch, roomMainMenu, roomLoadSave], LAYER_CONTROLLERS_BEHIND),
	new GameController(objNotification, [], [roomLaunch, roomMainMenu], LAYER_CONTROLLERS_FRONT),
	
	new GameController(objDatabase, [], [roomLaunch, roomMainMenu]),
	new GameController(objInventory, [], [roomLaunch, roomMainMenu]),
	new GameController(objTempInventory, [], [roomLaunch, roomMainMenu, roomLoadSave]),
	new GameController(objJournal, [], [roomLaunch, roomMainMenu]),
	new GameController(objQuest, [], [roomLaunch, roomMainMenu]),
	
	new GameController(objMap, [], [roomLaunch, roomMainMenu], LAYER_CONTROLLERS_BEHIND),

	
	new GameController(objInstanceHighlighter, [], [roomLaunch, roomMainMenu, roomLoadSave], LAYER_HIGHLIGHT_INTERACTABLE),
	
	new GameController(objGridPath, [], [roomLaunch, roomMainMenu, roomLoadSave]),
	
	// LOAD THE GAME SAVE OBJECT LAST
	// TO SET THE WORLD STATE AFTER EVERYTHING IS LOADED
	new GameController(objGameSave, [], [roomLaunch]),
];

controllerLayers = ds_map_create();
ds_map_add(controllerLayers, LAYER_CONTROLLERS, depth);
ds_map_add(controllerLayers, LAYER_CONTROLLERS_BEHIND, depth + 1);
ds_map_add(controllerLayers, LAYER_CONTROLLERS_FRONT, depth - 1);
ds_map_add(controllerLayers, LAYER_CONTROLLERS_ALL_FRONT, depth - 2);

ds_map_add(controllerLayers, LAYER_HIGHLIGHT_TARGET, depth); // DEPTH CHANGED AT RUNTIME
ds_map_add(controllerLayers, LAYER_HIGHLIGHT_INTERACTABLE, depth); // DEPTH CHANGED AT RUNTIME

// ROOM FADE-IN EFFECT
roomFadeAlphaStart = 1;
roomFadeAlpha = roomFadeAlphaStart;
roomFadeAlphaStep = 0.015;