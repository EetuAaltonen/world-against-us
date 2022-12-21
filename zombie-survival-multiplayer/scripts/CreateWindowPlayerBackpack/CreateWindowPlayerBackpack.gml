function CreateWindowPlayerBackpack(_zIndex)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	
	var backpackWindow = new GameWindow(
		GAME_WINDOW.PlayerBackpack,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var backpackElements = ds_list_create();
	// INVENTORY
	var backpackTitle = new WindowText(
		"BackpackTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Backpack", font_large, fa_center, fa_middle, c_white, 1
		
	);
	var inventoryGrid = new WindowInventoryGrid(
		"BackpackInventoryGrid",
		new Vector2(10, 60),
		new Size(windowSize.w - 20, 0),
		undefined,
		global.PlayerBackpack
	);
	// MAGAZINE POCKETS
	var magazinePocketTitle = new WindowText(
		"MagazinePocketTitle",
		new Vector2(windowSize.w - 10, 530),
		undefined, undefined,
		"Magazine Pockets", font_default, fa_right, fa_middle, c_white, 1
		
	);
	var magazinePocketGridSize = new Size(windowSize.w * 0.33, 0);
	var magazinePocketGrid = new WindowInventoryGrid(
		"MagazinePocketGrid",
		new Vector2(windowSize.w - magazinePocketGridSize.w - 10, 550),
		magazinePocketGridSize,
		undefined,
		global.PlayerMagazinePockets
	);
	// MEDICINE POCKETS
	var medicinePocketTitle = new WindowText(
		"MedicinePocketTitle",
		new Vector2(10, 530),
		undefined, undefined,
		"Medicine Pockets", font_default, fa_left, fa_middle, c_white, 1
		
	);
	var medicinePocketGridSize = new Size(windowSize.w * 0.33, 0);
	var medicinePocketGrid = new WindowInventoryGrid(
		"MedicinePocketGrid",
		new Vector2(10, 550),
		medicinePocketGridSize,
		undefined,
		global.PlayerMedicinePockets
	);
	
	ds_list_add(backpackElements,
		backpackTitle,
		inventoryGrid,
		magazinePocketTitle,
		magazinePocketGrid,
		medicinePocketTitle,
		medicinePocketGrid
	);
	
	backpackWindow.AddChildElements(backpackElements);
	return backpackWindow;
}