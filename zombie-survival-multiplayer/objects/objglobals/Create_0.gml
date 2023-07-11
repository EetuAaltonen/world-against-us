// NETWORKING
#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"

// SAVE FILES
#macro SAVE_FILE_SUFFIX "_save.json"
#macro EMPTY_SAVE_DATA "{ }"

// SPRITE MODIFIERS
#macro SPRITE_ERROR sprError
#macro SPRITE_NO_MASK sprNoMask

// COLLISION
#macro OBJECTS_TO_HIT [objHitbox]

// LAYERS
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_CONTROLLERS_BEHIND "Controllers_Behind"
#macro LAYER_CONTROLLERS_FRONT "Controllers_Front"
#macro LAYER_CONTROLLERS_ALL_FRONT "Controllers_All_Front"

#macro LAYER_HIGHLIGHT_INTERACTABLE "HighlightedInteractable"
#macro LAYER_HIGHLIGHT_TARGET "HighlightedTarget"

// GUI STATE
#macro ROOT_GUI_STATE new GUIState(GUI_STATE.GameRoot, undefined, undefined, [], GUI_CHAIN_RULE.OverwriteAll, CallbackGUIStateInputRoot, undefined)

// DIALOGUE
#macro DIALOGUE_DEFAULT_INDEX "default"

// DEFAULT KEYBINDINGS
#macro KEY_ESC_MENU	vk_escape
#macro KEY_PLAYER_OVERVIEW vk_tab
#macro KEY_JOURNAL ord("J")
#macro KEY_MAP ord("M")

// WORLD STATE INDICES
#macro WORLD_STATE_UNLOCK_WALKIE_TALKIE "UnlockWalkieTalkie"

// SET RANDOM SEED
randomise();

initGlobalVariables = function()
{
	// DEBUG MODE
	global.DEBUGMODE = false;
	
	// Global controllers
	global.ObjCamera = noone;
	global.GUIStateHandlerRef = undefined;
	global.GameWindowHandlerRef = undefined;
	global.ObjHud = noone;
	global.WorldStateData = undefined;
	global.DialogueHandlerRef = undefined;

	// Global Database
	global.ItemData = undefined;
	global.BulletData = undefined;
	global.LootTableData = undefined;
	global.QuestData = undefined;
	global.DialogueData = undefined;
	global.MapIconStyleData = undefined;

	global.PlayerBackpack = undefined;
	global.PlayerPrimaryWeaponSlot = undefined;
	global.PlayerMagazinePockets = undefined;
	global.PlayerMedicinePockets = undefined;
	
	// Journal
	global.ObjJournal = noone;
	
	// Quest Handler
	global.QuestHandlerRef = undefined;
	
	// Map
	global.ObjMap = noone;

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