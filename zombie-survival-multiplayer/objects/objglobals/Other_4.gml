// RESET GLOBAL VARIABLES
initGlobalVariables();

// FETCH GLOBAL VARIABLES AND OBJECTS
if (instance_exists(objCamera)) global.ObjCamera = instance_find(objCamera, 0);
if (instance_exists(objGUI)) global.GUIStateHandler = instance_find(objGUI, 0).stateHandler;
if (instance_exists(objGameWindow)) global.GameWindowHandler = instance_find(objGameWindow, 0).gameWindowHandler;
if (instance_exists(objHud)) global.ObjHud = instance_find(objHud, 0);

if (instance_exists(objDatabase))
{
	var databaseInstance = instance_find(objDatabase, 0);
	global.ItemData = databaseInstance.itemData;
	global.BulletData = databaseInstance.bulletData;
	
	global.QuestData = databaseInstance.questData;
}

if (instance_exists(objNetwork)) global.ObjNetwork = instance_find(objNetwork, 0);

if (instance_exists(objGameSave)) global.GameSaveHandlerRef = instance_find(objGameSave, 0).gameSaveHandler;

if (instance_exists(objMouse)) global.ObjMouse = instance_find(objMouse, 0);

if (instance_exists(objInventory)) global.PlayerBackpack = instance_find(objInventory, 0).inventory;
if (instance_exists(objInventory)) global.PlayerMagazinePockets = instance_find(objInventory, 0).magazinePockets;
if (instance_exists(objInventory)) global.PlayerMedicinePockets = instance_find(objInventory, 0).medicinePockets;

if (instance_exists(objTempInventory)) global.ObjTempInventory = instance_find(objTempInventory, 0);

if (instance_exists(objSpawner)) global.ObjSpawner = instance_find(objSpawner, 0);
	
if (instance_exists(objJournal)) global.ObjJournal = instance_find(objJournal, 0);
if (instance_exists(objQuest)) global.QuestHandlerRef = instance_find(objQuest, 0).questHandler;

if (instance_exists(objMessageLog)) global.MessageLog = instance_find(objMessageLog, 0).messages;
if (instance_exists(objNotification)) global.NotificationHandlerRef = instance_find(objNotification, 0).notificationHandler;

if (instance_exists(objInstanceHighlight)) global.HighlightHandlerRef = instance_find(objInstanceHighlight, 0).highlightHandler;

if (instance_exists(objGridPath)) global.ObjGridPath = instance_find(objGridPath, 0);

// Fetch view variables
global.ViewW = view_wport[0];
global.ViewH = view_hport[0];

global.GUIW = display_get_gui_width();
global.GUIH = display_get_gui_height();