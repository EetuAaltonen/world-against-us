#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"
#macro SAVE_FILE_SUFFIX "_save.json"

// SET RANDOM SEED
randomise();

initGlobalVariables = function()
{
	// Global controllers
	global.ObjCamera = noone;
	global.GUIStateHandler = undefined;
	global.ObjHud = noone;

	global.ItemData = undefined;
	global.BulletData = undefined;

	global.PlayerBackpack = undefined;
	global.PlayerMagazinePockets = undefined;
	global.PlayerMedicinePockets = undefined;
	
	// Journal
	global.ObjJournal = noone;
	// Quest
	global.QuestData = undefined;
	global.QuestHandlerRef = undefined;

	// Player
	global.ObjPlayer = noone;
	global.ObjSpawner = noone;

	// Network
	global.ObjNetwork = noone;
	
	// Game save
	global.GameSaveHandlerRef = undefined;
	
	// Highlight
	global.HighlightHandlerRef = undefined;

	// Coop
	global.OtherPlayerData = ds_map_create();

	global.ObjWeapon = noone;

	// View variables
	global.ViewW = 0;
	global.ViewH = 0;

	// GUI
	global.GUIW = 0;
	global.GUIH = 0;

	// Mouse
	global.ObjMouse = noone;

	// Message log
	global.MessageLog = undefined;
	// Notification
	global.NotificationHandlerRef = undefined;

	// AI Path
	global.ObjGridPath = undefined;
}

// INIT GLOBAL VARIABLES
initGlobalVariables();