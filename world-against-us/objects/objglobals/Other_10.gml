/// @description Custom RoomStartEvent

// FETCH GLOBAL CONTROLLERS AND INSTANCES
global.GameWindowHandlerRef = instance_exists(objGameWindow) ? instance_find(objGameWindow, 0).gameWindowHandler : undefined;
global.ObjCamera = instance_exists(objCamera) ? instance_find(objCamera, 0) : noone;
global.GUIStateHandlerRef = instance_exists(objGUI) ? instance_find(objGUI, 0).guiStateHandler : undefined;
global.ObjMouse = instance_exists(objMouse) ? instance_find(objMouse, 0) : noone;
global.NotificationHandlerRef = instance_exists(objNotification) ? instance_find(objNotification, 0).notificationHandler : undefined;
global.ConsoleHandlerRef = instance_exists(objConsole) ? instance_find(objConsole, 0).consoleHandler : undefined;
global.ObjNetwork = instance_exists(objNetwork) ? instance_find(objNetwork, 0) : noone;
global.NetworkHandlerRef = instance_exists(objNetwork) ? instance_find(objNetwork, 0).networkHandler : undefined;
global.NetworkRegionHandlerRef = (!is_undefined(global.NetworkHandlerRef)) ? global.NetworkHandlerRef.network_region_handler : undefined;
global.NetworkRegionObjectHandlerRef = (!is_undefined(global.NetworkRegionHandlerRef)) ? global.NetworkRegionHandlerRef.network_region_object_handler : undefined;
global.NetworkPacketTrackerRef = (!is_undefined(global.NetworkHandlerRef)) ? global.NetworkHandlerRef.network_packet_tracker : undefined;
global.NetworkPacketDeliveryPolicies = (!is_undefined(global.NetworkHandlerRef)) ? global.NetworkHandlerRef.network_packet_delivery_policy_handler.delivery_policies : undefined;
global.NetworkConnectionSamplerRef = (!is_undefined(global.NetworkHandlerRef)) ? global.NetworkHandlerRef.network_connection_sampler : undefined;

global.WorldStateHandlerRef = instance_exists(objWorldState) ? instance_find(objWorldState, 0).worldStateHandler : undefined;
global.WorldStateData = (!is_undefined(global.WorldStateHandlerRef)) ? global.WorldStateHandlerRef.world_states : undefined;

global.ItemDatabase = instance_exists(objDatabase) ? instance_find(objDatabase, 0).itemDatabase : undefined;
global.BlueprintData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).blueprintData : undefined;
global.LootTableData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).lootTableData : undefined;
global.QuestData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).questData : undefined;
global.DialogueData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).dialogueData : undefined;
global.ObjectExamineData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).objectExamineData : undefined;
global.WorldMapLocationData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).worldMapLocationData : undefined;
global.MapIconStyleData = instance_exists(objDatabase) ? instance_find(objDatabase, 0).mapIconStyleData : undefined;

global.ObjHud = instance_exists(objHud) ? instance_find(objHud, 0) : noone;
global.QuestHandlerRef = instance_exists(objQuest) ? instance_find(objQuest, 0).questHandler : undefined;
global.ObjJournal = instance_exists(objJournal) ? instance_find(objJournal, 0) : noone;
global.DialogueHandlerRef = instance_exists(objDialogue) ? instance_find(objDialogue, 0).dialogueHandler : undefined;
global.MapDataHandlerRef = instance_exists(objMap) ? instance_find(objMap, 0).mapDataHandler : undefined;
global.RoomChangeHandlerRef = instance_exists(objRoomChange) ? instance_find(objRoomChange, 0).roomChangeHandler : undefined;
global.SpawnHandlerRef = instance_exists(objSpawn) ? instance_find(objSpawn, 0).spawnHandler : undefined;

global.PlayerDataHandlerRef = instance_exists(objPlayerData) ? instance_find(objPlayerData, 0).playerDataHandler : undefined;
global.PlayerCharacter = (!is_undefined(global.PlayerDataHandlerRef)) ? global.PlayerDataHandlerRef.character : undefined;
global.GameSaveHandlerRef = instance_exists(objGameSave) ? instance_find(objGameSave, 0).gameSaveHandler : undefined;

global.InstanceDrone = instance_exists(objDrone) ? instance_find(objDrone, 0) : noone;

global.HighlightHandlerRef = instance_exists(objInstanceHighlighter) ? instance_find(objInstanceHighlighter, 0).highlightHandler : undefined;
global.ObjGridPath = instance_exists(objGridPath) ? instance_find(objGridPath, 0) : noone;
global.ObjTempInventory = instance_exists(objTempInventory) ? instance_find(objTempInventory, 0) : noone;