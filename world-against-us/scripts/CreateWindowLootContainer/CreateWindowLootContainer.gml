function CreateWindowLootContainer(_gameWindowId, _zIndex, _containerInventory)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var containerWindow = new GameWindow(
		_gameWindowId,
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var containerElements = ds_list_create();
	// CONTAINER TITLE
	var containerTitle = new WindowText(
		"ContainerTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Loot Container", font_large, fa_center, fa_middle, c_white, 1
		
	);
	
	// LOOT INVENTORY
	var containerInventoryGrid = new WindowInventoryGrid(
		"ContainerInventoryGrid",
		new Vector2(10, 70),
		new Size(windowSize.w - 20, 0),
		undefined, _containerInventory
	);
	
	ds_list_add(containerElements,
		containerTitle,
		containerInventoryGrid
	);
	
	containerWindow.AddChildElements(containerElements);
	return containerWindow;
}