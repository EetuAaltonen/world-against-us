/// @description Custom RoomStartEvent

// FETCH GLOBAL CONTROLLERS AND INSTANCES
if (is_undefined(global.GameWindowHandlerRef)) if (instance_exists(objGameWindow)) global.GameWindowHandlerRef = instance_find(objGameWindow, 0).gameWindowHandler;
if (global.ObjCamera == noone) if (instance_exists(objCamera)) global.ObjCamera = instance_find(objCamera, 0);
if (is_undefined(global.GUIStateHandlerRef)) if (instance_exists(objGUI)) global.GUIStateHandlerRef = instance_find(objGUI, 0).guiStateHandler;
if (global.ObjMouse == noone) if (instance_exists(objMouse)) global.ObjMouse = instance_find(objMouse, 0);
if (is_undefined(global.NotificationHandlerRef)) if (instance_exists(objNotification)) global.NotificationHandlerRef = instance_find(objNotification, 0).notificationHandler;
if (global.ObjNetwork == noone) if (instance_exists(objNetwork)) global.ObjNetwork = instance_find(objNetwork, 0);
if (instance_exists(objDatabase))
{
	var databaseInstance = instance_find(objDatabase, 0);
	if (is_undefined(global.ItemDatabase)) global.ItemDatabase = databaseInstance.itemDatabase;
	if (is_undefined(global.BlueprintData)) global.BlueprintData = databaseInstance.blueprintData;
	if (is_undefined(global.LootTableData)) global.LootTableData = databaseInstance.lootTableData;
	if (is_undefined(global.QuestData)) global.QuestData = databaseInstance.questData;
	if (is_undefined(global.DialogueData)) global.DialogueData = databaseInstance.dialogueData;
	if (is_undefined(global.MapIconStyleData)) global.MapIconStyleData = databaseInstance.mapIconStyleData;
}
if (global.ObjHud == noone) if (instance_exists(objHud)) global.ObjHud = instance_find(objHud, 0);
if (is_undefined(global.WorldStateData)) if (instance_exists(objWorldState)) global.WorldStateData = instance_find(objWorldState, 0).worldStateHandler.world_states;
if (is_undefined(global.QuestHandlerRef)) if (instance_exists(objQuest)) global.QuestHandlerRef = instance_find(objQuest, 0).questHandler;
if (global.ObjJournal == noone) if (instance_exists(objJournal)) global.ObjJournal = instance_find(objJournal, 0);
if (is_undefined(global.DialogueHandlerRef)) if (instance_exists(objDialogue)) global.DialogueHandlerRef = instance_find(objDialogue, 0).dialogueHandler;
if (global.ObjMap == noone) if (instance_exists(objMap)) global.ObjMap = instance_find(objMap, 0);
if (instance_exists(objInventory))
{
	var inventoryInstance = instance_find(objInventory, 0);
	if (is_undefined(global.PlayerBackpack)) global.PlayerBackpack = inventoryInstance.inventory;
	if (is_undefined(global.PlayerPrimaryWeaponSlot)) global.PlayerPrimaryWeaponSlot = inventoryInstance.playerPrimaryWeaponSlot;
	if (is_undefined(global.PlayerAmmoPockets)) global.PlayerAmmoPockets = inventoryInstance.magazinePockets;
	if (is_undefined(global.PlayerMedicinePockets)) global.PlayerMedicinePockets = inventoryInstance.medicinePockets;
}
if (is_undefined(global.HighlightHandlerRef)) if (instance_exists(objInstanceHighlighter)) global.HighlightHandlerRef = instance_find(objInstanceHighlighter, 0).highlightHandler;
if (global.ObjGridPath == noone) if (instance_exists(objGridPath)) global.ObjGridPath = instance_find(objGridPath, 0);
if (global.ObjTempInventory == noone) if (instance_exists(objTempInventory)) global.ObjTempInventory = instance_find(objTempInventory, 0);
if (is_undefined(global.GameSaveHandlerRef)) if (instance_exists(objGameSave)) global.GameSaveHandlerRef = instance_find(objGameSave, 0).gameSaveHandler;