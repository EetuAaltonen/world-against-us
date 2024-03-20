// SET RANDOM SEED
randomise();

// DISPLAY
#macro VIEW_BASE_WIDTH 640
#macro VIEW_BASE_HEIGHT 360
#macro GUI_BASE_WIDTH 1920
#macro GUI_BASE_HEIGHT 1080

// STRING
#macro EMPTY_STRING ""
#macro STRING_LINE_BREAK "\n"
#macro STRING_LINE_BREAK_WINDOWS "\r\n"

// NUMERIC
#macro FIXED_POINT_PRECISION 10
#macro FIXED_POINT_PERCENT_PRECISION 1000

// STRUCT
#macro EMPTY_STRUCT {}

// OBJECT
#macro UNDEFINED_OBJECT_NAME "<undefined>"

// SAVE FILES
#macro SAVE_FILE_SUFFIX_PLAYER_DATA "_save_player_data.json"
#macro SAVE_FILE_SUFFIX_ROOM "_save_{0}.json"
#macro EMPTY_SAVE_DATA "{ }"
#macro MAX_SAVE_NAME_LENGTH 24

// NETWORKING
#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"
#macro DEFAULT_HOST_PORT 54544

// NETWORKING CLIENT
#macro MAX_PLAYER_TAG_LENGTH 16
#macro MIN_PLAYER_TAG_LENGTH 3
#macro MAX_ADDRESS_LENGTH 124
#macro MAX_PORT_NUMBER_LENGTH 16

// NETOWRKING SYNC INTERVALS (ms)
#macro INSTANCE_SNAPSHOT_SYNC_INTERVAL 1000
#macro MAP_DATA_UPDATE_INTERVAL 500

// SPRITE MODIFIERS
#macro SPRITE_ERROR sprError
#macro SPRITE_NO_MASK sprNoMask
#macro ITEM_DEFAULT_ANGLE 0
#macro ITEM_ROTATED_ANGLE 90
#macro MAX_SPRITE_SIZE 100000

// COLLISION
#macro OBJECTS_TO_HIT [objHitbox]

// LAYERS
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_CONTROLLERS_BEHIND "Controllers_Behind"
#macro LAYER_CONTROLLERS_FRONT "Controllers_Front"
#macro LAYER_CONTROLLERS_ALL_FRONT "Controllers_All_Front"

#macro LAYER_CHARACTERS "Characters"

#macro LAYER_HIGHLIGHT_INTERACTABLE "HighlightedInteractable"
#macro LAYER_HIGHLIGHT_TARGET "HighlightedTarget"

#macro LAYER_EFFECT_PREFIX "Effect"
#macro LAYER_EFFECT_LIGHT "EffectLight"

#macro LAYER_PATH_PATROL "PathPatrol"

// GUI STATE
#macro ROOT_GUI_STATE new GUIState(GUI_STATE.GameRoot, undefined, undefined, [], GUI_CHAIN_RULE.OverwriteAll, CallbackGUIStateInputRoot, undefined)

// PARENT OBJECT EVENT 0
#macro OBJECT_PARENTS_WITH_EVENT_0 [objInteractableParent, objCharacterParent]

// DIALOGUE
#macro DIALOGUE_DEFAULT_INDEX "default"

// DEFAULT KEYBINDINGS
#macro KEY_ESC_MENU	vk_escape
#macro KEY_CONSOLE vk_f1
#macro KEY_DEBUG_MONITOR vk_f5
#macro KEY_DEBUG_OVERLAY vk_f6
#macro KEY_DEBUG_PLAYER_AUTOPILOT vk_f9
#macro KEY_PLAYER_OVERVIEW vk_tab
#macro KEY_JOURNAL ord("J")
#macro KEY_MAP ord("M")
#macro KEY_PLAYER_LIST ord("O")

// WORLD STATE INDICES
#macro WORLD_STATE_UNLOCK_WALKIE_TALKIE "UnlockWalkieTalkie"

// WORLD STATE WEATHER NAMES
#macro WEATHER_TEXT ["Clear", "Windy", "Cloudy", "Foggy", "Rainy"]


// ROOMS
// TODO: Move these inside a map locations data file to read
#macro ROOM_INDEX_MAIN_MENU "roomMainMenu"
#macro ROOM_INDEX_LOAD_RESOURCES "roomLoadResources"
#macro ROOM_INDEX_CAMP "roomCamp"
#macro ROOM_INDEX_TOWN "roomTown"
#macro ROOM_INDEX_OFFICE "roomOffice"
#macro ROOM_INDEX_LIBRARY "roomLibrary"
#macro ROOM_INDEX_MARKET "roomMarket"
#macro ROOM_INDEX_FOREST "roomForest"

#macro ROOM_DEFAULT ROOM_INDEX_CAMP
#macro IS_ROOM_IN_GAME_WORLD (room != roomLaunch && room != roomMainMenu && room != roomLoadResources)
#macro IS_ROOM_PATROL_ROUTED (layer_exists(LAYER_PATH_PATROL))

// INSTANCES
#macro CAMP_INSTANCE_ID 0

// CONTAINER
#macro CAMP_STORAGE_CONTAINER_ID "camp_storage_container"

// MAP ICON TYPE
#macro STATIC_MAP_ICON "static_icon"
#macro DYNAMIC_MAP_ICON "dynamic_icon"

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
global.ConsoleHandlerRef = undefined;
global.DebugMonitorGameHandlerRef = undefined;
global.DebugMonitorNetworkHandlerRef = undefined;
global.DebugMonitorMultiplayerHandlerRef = undefined;
global.NotificationHandlerRef = undefined;
global.ObjNetwork = noone;
global.NetworkHandlerRef = undefined;
global.ObjHud = noone;
global.ObjJournal = noone;
global.QuestHandlerRef = undefined;
global.DialogueHandlerRef = undefined;
global.MapDataHandlerRef = undefined;
global.RoomChangeHandlerRef = undefined;
global.SpawnHandlerRef = undefined;
global.HighlightHandlerRef = undefined;
global.PlayerDataHandlerRef = undefined;
global.GameSaveHandlerRef = undefined;

// GLOBAL WORLD STATE
global.WorldStateHandlerRef = undefined;
global.WorldStateData = undefined;

// GLOBAL DATABASE
global.ItemDatabase = undefined;
global.BlueprintData = undefined;
global.LootTableData = undefined;
global.QuestData = undefined;
global.DialogueData = undefined;
global.ObjectExamineData = undefined;
global.WorldMapLocationData = undefined;
global.MapIconStyleData = undefined;

// PLAYER INVENTORY
global.PlayerCharacter = undefined;
global.PlayerBackpack = undefined;
global.PlayerPrimaryWeaponSlot = undefined;
global.PlayerMagazinePockets = undefined;
global.PlayerMedicinePockets = undefined;

// TEMP INVENTORY
global.ObjTempInventory = noone;

// NPC HANDLER
global.NPCHandlerRef = undefined;
global.NPCPatrolHandlerRef = undefined;

// NETWORKING
global.MultiplayerMode = false;
global.NetworkRegionHandlerRef = undefined;
global.NetworkRegionRemotePlayerHandlerRef = undefined;
global.NetworkRegionObjectHandlerRef = undefined;
global.NetworkPacketTrackerRef = undefined;
global.NetworkConnectionSamplerRef = undefined;
global.NetworkPacketDeliveryPolicies = undefined;

// DRONE
global.InstanceDrone = noone;

resetDynamicVariables = function()
{
	// PLAYER
	global.InstancePlayer = noone;
	
	// WEAPON
	global.InstanceWeapon = noone;
	
	// DRONE
	global.InstanceDrone = noone;

	// AI GRID PATH
	global.ObjGridPath = undefined;
}

// INIT GLOBAL VARIABLES
resetDynamicVariables();