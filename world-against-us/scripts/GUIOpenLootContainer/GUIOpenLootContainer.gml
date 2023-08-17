function GUIOpenLootContainer()
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	
	var lootContainerWindow = new GameWindow(
		"lootContainerWindow",
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, -1
	);
	
	var lootContainerElements = ds_list_create();
	var lootContainerTitle = new WindowText(
		"BackpackTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Loot Container", font_large, fa_center, fa_middle, c_white, 1
		
	);
	var inventoryGrid = new WindowInventoryGrid(
		"LootContainerInventoryGrid",
		new Vector2(10, 60),
		new Size(windowSize.w - 20, 0),
		#5c513c,
		global.ObjTempInventory.inventory
	);
	
	ds_list_add(lootContainerElements,
		lootContainerTitle,
		inventoryGrid
	);
	
	// ADD NEW WINDOW
	lootContainerWindow.AddChildElements(lootContainerElements);
	global.GameWindowHandlerRef.OpenWindow(lootContainerWindow);
}