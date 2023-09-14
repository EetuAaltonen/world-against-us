function CreateWindowGardenBed(_gameWindowId, _zIndex, _toolsInventory, _fertilizeInventory, _waterInventory, _seedInventory, _outputInventory)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var gardenWindow = new GameWindow(
		_gameWindowId,
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var gardenElements = ds_list_create();
	// GARDEN TITLE
	var gardenTitle = new WindowText(
		"GardenTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Garden bed", font_large, fa_center, fa_middle, c_white, 1
	);
	
	// ITEM HOLDERS
	var gardenItemHolderSize = new Size(150, 150);
	var toolsTitle = new WindowText(
		"ToolsTitle",
		new Vector2(50 + (gardenItemHolderSize.w * 0.5), 90),
		undefined, undefined,
		"Tools", font_small, fa_center, fa_middle, c_white, 1
	);
	var toolsItemHolder = new WindowItemSlot(
		"ToolsInventory",
		new Vector2(50, 100),
		gardenItemHolderSize,
		c_gray, _toolsInventory
	);
	var fertilizerTitle = new WindowText(
		"FertilizerTitle",
		new Vector2((windowSize.w * 0.5), 90),
		undefined, undefined,
		"Fertilizer", font_small, fa_center, fa_middle, c_white, 1
	);
	var fertilizerItemHolder = new WindowItemSlot(
		"FertilizerInventory",
		new Vector2((windowSize.w * 0.5) - (gardenItemHolderSize.w * 0.5), 100),
		gardenItemHolderSize,
		c_gray, _fertilizeInventory
	);
	var waterTitle = new WindowText(
		"WaterTitle",
		new Vector2(windowSize.w - 50 - (gardenItemHolderSize.w * 0.5), 90),
		undefined, undefined,
		"Water", font_small, fa_center, fa_middle, c_white, 1
	);
	var waterItemHolder = new WindowItemSlot(
		"WaterInventory",
		new Vector2(windowSize.w - gardenItemHolderSize.w - 50, 100),
		gardenItemHolderSize,
		c_gray, _waterInventory
	);
	var seedTitle = new WindowText(
		"SeedTitle",
		new Vector2((windowSize.w * 0.5), 270),
		undefined, undefined,
		"Seeds", font_small, fa_center, fa_middle, c_white, 1
	);
	var seedItemHolderSize = new Size(100, 100);
	var seedItemHolder = new WindowItemSlot(
		"SeedInventory",
		new Vector2((windowSize.w * 0.5) - (seedItemHolderSize.w * 0.5), 280),
		seedItemHolderSize,
		c_gray, _seedInventory
	);
	var outputTitle = new WindowText(
		"OutputTitle",
		new Vector2(10, 390),
		undefined, undefined,
		"Harvest", font_small, fa_left, fa_middle, c_white, 1
	);
	var outputInventoryGrid = new WindowInventoryGrid(
		"OutputInventoryGrid",
		new Vector2(10, 400),
		new Size(windowSize.w - 20, 0),
		undefined,
		_outputInventory
	);
	
	ds_list_add(gardenElements,
		gardenTitle,
		toolsTitle,
		toolsItemHolder,
		fertilizerTitle,
		fertilizerItemHolder,
		waterTitle,
		waterItemHolder,
		seedTitle,
		seedItemHolder,
		outputTitle,
		outputInventoryGrid
	);
	
	gardenWindow.AddChildElements(gardenElements);
	return gardenWindow;
}