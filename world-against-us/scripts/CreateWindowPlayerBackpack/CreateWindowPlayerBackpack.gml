function CreateWindowPlayerBackpack(_gameWindowId, _zIndex)
{
	var windowSize = new Size(1000, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var backpackWindow = new GameWindow(
		_gameWindowId,
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
	var backpackItemRef = global.PlayerCharacter.gear.GetItemBySlot(global.PlayerCharacter.gear.backpack);
	var backpackInventoryRef = (!is_undefined(backpackItemRef)) ? backpackItemRef.metadata.inventory : undefined;
	var inventoryGrid = new WindowInventoryGrid(
		"BackpackInventoryGrid",
		new Vector2(10, 60),
		new Size(760, 0),
		undefined,
		backpackInventoryRef
	);
	
	// BACKPACK SLOT
	var backpackSlotSize = new Size(150, 200);
	var backpackSlotPosition = new Vector2((windowSize.w - 20) - backpackSlotSize.w, 60);
	
	var backpackSlotTitle = new WindowText(
		"BackpackSlotTitle",
		new Vector2(backpackSlotPosition.X, backpackSlotPosition.Y - 10),
		undefined, undefined,
		"Backpack", font_small, fa_left, fa_middle, c_white, 1
	);
	
	var backpackSlot = new WindowItemSlot(
		"BackpackSlot",
		backpackSlotPosition,
		backpackSlotSize,
		c_gray, global.PlayerCharacter.gear.backpack,
		CallbackItemSlotPlayerBackpack
	);
	
	// GEAR SLOT PRIMARY WEAPON
	var primaryWeaponSlotSize = new Size(300, 150);
	var primaryWeaponSlotPosition = new Vector2(10, (windowSize.h - primaryWeaponSlotSize.h - 10));
	
	var primaryWeaponSlotTitle = new WindowText(
		"PrimaryWeaponSlotTitle",
		new Vector2(primaryWeaponSlotPosition.X, primaryWeaponSlotPosition.Y - 10),
		undefined, undefined,
		"Primary Weapon", font_small, fa_left, fa_middle, c_white, 1
	);
	var gearSlotInventory = global.PlayerCharacter.gear.primary_weapon;
	var primaryWeaponSlot = new WindowItemSlot(
		"PrimaryWeaponSlot",
		primaryWeaponSlotPosition,
		primaryWeaponSlotSize,
		c_gray, gearSlotInventory,
		CallbackItemSlotGearSlot
	);
	
	ds_list_add(backpackElements,
		backpackTitle,
		inventoryGrid,
		backpackSlotTitle,
		backpackSlot,
		primaryWeaponSlotTitle,
		primaryWeaponSlot
	);
	
	backpackWindow.AddChildElements(backpackElements);
	return backpackWindow;
}