// ROOM START AFTER
if (onRoomStartAfter)
{
	onRoomStartAfter = false;
	
	// RESET GLOBAL VARIABLES
	initGlobalVariables();
	
	// FETCH GLOBAL VARIABLES AND OBJECTS
	if (instance_exists(objCamera)) global.ObjCamera = instance_find(objCamera, 0);
	if (instance_exists(objGUI)) global.GUIStateHandler = instance_find(objGUI, 0).stateHandler;
	if (instance_exists(objGameWindow)) global.GameWindowHandler = instance_find(objGameWindow, 0).gameWindowHandler;
	if (instance_exists(objHud)) global.ObjHud = instance_find(objHud, 0);

	if (instance_exists(objDatabase))
	{
		global.ItemData = instance_find(objDatabase, 0).itemData;
		global.BulletData = instance_find(objDatabase, 0).bulletData;
	}

	if (instance_exists(objNetwork)) global.ObjNetwork = instance_find(objNetwork, 0);

	if (instance_exists(objMouse)) global.ObjMouse = instance_find(objMouse, 0);

	if (instance_exists(objInventory)) global.PlayerBackpack = instance_find(objInventory, 0).inventory;
	if (instance_exists(objInventory)) global.PlayerMagazinePockets = instance_find(objInventory, 0).magazinePockets;
	if (instance_exists(objInventory)) global.PlayerMedicinePockets = instance_find(objInventory, 0).medicinePockets;

	if (instance_exists(objTempInventory)) global.ObjTempInventory = instance_find(objTempInventory, 0);

	if (instance_exists(objSpawner)) global.ObjSpawner = instance_find(objSpawner, 0);

	if (instance_exists(objMessageLog)) global.MessageLog = instance_find(objMessageLog, 0).messages;

	if (instance_exists(objGridPath)) global.RoomGrid = instance_find(objGridPath, 0).roomGrid;

	// Fetch view variables
	global.ViewW = view_wport[0];
	global.ViewH = view_hport[0];

	global.GUIW = display_get_gui_width();
	global.GUIH = display_get_gui_height();
}

if (global.ObjPlayer == noone)
{
	if (instance_exists(objPlayer))
	{
		global.ObjPlayer = instance_find(objPlayer, 0);
	}
}

if (global.ObjWeapon == noone)
{
	if (global.ObjPlayer != noone)
	{
		global.ObjWeapon = global.ObjPlayer.weapon;
	}
}
