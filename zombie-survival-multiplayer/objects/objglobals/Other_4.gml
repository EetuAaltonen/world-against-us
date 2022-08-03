// Fetch global controllers
if (instance_exists(objCamera)) global.ObjCamera = instance_find(objCamera, 0);
if (instance_exists(objGUI)) global.ObjGUI = instance_find(objGUI, 0);

if (instance_exists(objInventory)) global.PlayerBackpack = instance_find(objInventory, 0).inventory;
if (instance_exists(objLootContainer)) global.ObjLootContainer = instance_find(objLootContainer, 0);

if (instance_exists(objSpawner)) global.ObjSpawner = instance_find(objSpawner, 0);

// Fetch view variables
global.ViewW = view_wport[0];
global.ViewH = view_hport[0];