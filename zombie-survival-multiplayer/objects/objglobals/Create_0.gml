#macro UNDEFINED_UUID "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined"

// SET RANDOM SEED
randomise();

// ROOM START AFTER
onRoomStartAfter = true;

initGlobalVariables = function()
{
	// Global controllers
	global.ObjCamera = noone;
	global.GUIStateHandler = undefined;
	global.ObjHud = noone;

	global.ItemData = noone;
	global.BulletData = undefined;

	global.PlayerBackpack = noone;
	global.PlayerMagazinePockets = undefined;
	global.PlayerMedicinePockets = undefined;

	// Player
	global.ObjPlayer = noone;
	global.ObjSpawner = noone;

	// Network
	global.ObjNetwork = noone;

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

	// AI Path
	global.RoomGrid = undefined;
}

// INIT GLOBAL VARIABLES
initGlobalVariables();