function CreateWindowStorageContainer(_gameWindowId, _zIndex, _containerInventory)
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
		"Camp storage", font_large, fa_center, fa_middle, c_white, 1
		
	);
	
	// LOOT INVENTORY
	var containerInventoryPosition = new Vector2(10, 70);
	var containerInventorySize = new Size(windowSize.w - 20, 0);
	var containerInventoryGrid = new WindowInventoryGrid(
		"ContainerInventoryGrid",
		containerInventoryPosition,
		containerInventorySize,
		undefined, _containerInventory
	);
	
	// LOADING ICON
	var containerInventoryLoadingSize = new Size(containerInventorySize.w, 220);
	var containerInventoryLoading = new WindowLoading(
		"ContainerInventoryLoading",
		containerInventoryPosition,
		containerInventoryLoadingSize,
		undefined
	);
	containerInventoryLoading.isVisible = false;
	
	ds_list_add(containerElements,
		containerTitle,
		containerInventoryGrid,
		containerInventoryLoading
	);
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// NETWORKING CLEAR IN-FLIGHT CONTAINER CONTENT REQUESTS
		if (global.MultiplayerMode)
		{
			// CLEAR LOOT CONTAINER INVENTORY CACHE
			var lootContainerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.StorageContainer);
			if (!is_undefined(lootContainerWindow))
			{
				var containerInventoryGridElement = lootContainerWindow.GetChildElementById("ContainerInventoryGrid");
				if (!is_undefined(containerInventoryGridElement))
				{
					// RESET CONTAINER ACCESS AND INVENTORY STREAM
					OnCloseWindowContainerNetwork(containerInventoryGridElement.inventory.inventory_id);
					
					containerInventoryGridElement.inventory.ClearAllItems();
				}
			}
		}
	}
	containerWindow.OnClose = overrideOnClose;
	
	containerWindow.AddChildElements(containerElements);
	return containerWindow;
}