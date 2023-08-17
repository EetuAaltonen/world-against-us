// SET RANDOM SEED
randomise();

// DISPLAY
#macro VIEW_BASE_WIDTH 640
#macro VIEW_BASE_HEIGHT 360
#macro GUI_BASE_WIDTH 1920
#macro GUI_BASE_HEIGHT 1080

// NETWORKING
#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"

// SAVE FILES
#macro SAVE_FILE_SUFFIX_PLAYER_DATA "_save_player_data.json"
#macro SAVE_FILE_SUFFIX_ROOM "_save_{0}.json"
#macro EMPTY_SAVE_DATA "{ }"

// STRUCT
#macro EMPTY_STRUCT {}

// SPRITE MODIFIERS
#macro SPRITE_ERROR sprError
#macro SPRITE_NO_MASK sprNoMask
#macro ITEM_DEFAULT_ANGLE 0
#macro ITEM_ROTATED_ANGLE 90

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

// DEBUG MODE
global.DEBUGMODE = false;

// FETCH VIEW PORT PROPERTIES
global.ViewW = view_wport[0];
global.ViewH = view_hport[0];
global.GUIW = display_get_gui_width();
global.GUIH = display_get_gui_height();

// GLOBAL CONTROLLERS
global.GameWindowHandlerRef = undefined;
global.ObjCamera = noone;
global.GUIStateHandlerRef = undefined;
global.ObjMouse = noone;
global.NotificationHandlerRef = undefined;
global.ObjNetwork = noone;
global.ObjHud = noone;
global.WorldStateData = undefined;
global.ObjJournal = noone;
global.QuestHandlerRef = undefined;
global.DialogueHandlerRef = undefined;
global.ObjMap = noone;
global.HighlightHandlerRef = undefined;
global.GameSaveHandlerRef = undefined;

// GLOBAL DATABASE
global.ItemDatabase = undefined;
global.BlueprintData = undefined;
global.LootTableData = undefined;
global.QuestData = undefined;
global.DialogueData = undefined;
global.MapIconStyleData = undefined;

// PLAYER INVENTORY
global.PlayerBackpack = undefined;
global.PlayerPrimaryWeaponSlot = undefined;
global.PlayerMagazinePockets = undefined;
global.PlayerMedicinePockets = undefined;

// TEMP INVENTORY
global.ObjTempInventory = noone;

resetDynamicVariables = function()
{
	// PLAYER
	global.InstancePlayer = noone;
	
	// WEAPON
	global.InstanceWeapon = noone;

	// COOP
	// TODO: Create handler for co-op player data
	global.OtherPlayerData = ds_map_create();

	// AI GRID PATH
	global.ObjGridPath = undefined;
}

// INIT GLOBAL VARIABLES
resetDynamicVariables();