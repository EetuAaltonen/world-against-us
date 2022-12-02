function GUIOpenPlayerBackpack()
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 1);
	
	var backpackWindow = new GameWindow(
		"BackpackWindow",
		new Vector2(0, 0),
		windowSize, windowStyle, -1
	);
	
	var backpackElements = ds_list_create();
	var backpackTitle = new WindowText(
		"BackpackTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Player Backpack", font_large, fa_center, fa_middle, c_white, 1
		
	);
	var inventoryGrid = new WindowInventoryGrid(
		"BackpackInventoryGrid",
		new Vector2(10, 60),
		new Size(windowSize.w - 20, 0),
		#5c513c,
		global.PlayerBackpack
	);
	
	ds_list_add(backpackElements,
		backpackTitle,
		inventoryGrid
	);
	
	// ADD NEW WINDOW
	backpackWindow.AddChildElements(backpackElements);
	ds_list_add(global.ObjWindowHandler.gameWindows, backpackWindow);
}