// NETWORKING
#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"

// SAVE FILES
#macro SAVE_FILE_SUFFIX "_save.json"
#macro EMPTY_SAVE_DATA "{ }"

// SPRITE MODIFIERS
#macro SPRITE_ERROR sprError
#macro SPRITE_NO_MASK sprNoMask

// DEFAULT KEYBINDINGS
#macro KEY_ESC_MENU	vk_escape
#macro KEY_PLAYER_OVERVIEW vk_tab
#macro KEY_JOURNAL ord("J")
#macro KEY_MAP ord("M")

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
	
	// Loot table
	global.LootTableData = undefined;
	
	// Journal
	global.ObjJournal = noone;
	// Quest
	global.QuestData = undefined;
	global.QuestHandlerRef = undefined;
	// Map
	global.ObjMap = noone;
	global.MapIconStyleData = undefined;


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