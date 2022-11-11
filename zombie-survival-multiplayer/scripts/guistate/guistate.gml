function IsGUIStateClosed() {
	return is_undefined(global.GUIState);
}

function RequestGUIState(_newGUIState)
{
	var stateUpdated = true;
	// SKIP IF GUI STATE NOT CHANGED
	if (_newGUIState == global.GUIState) { return stateUpdated; }
	
	// CLOSE ALL WINDOWS
	ds_list_clear(global.ObjWindowHandler.gameWindows);
	
	switch (_newGUIState)
	{
		case GUI_STATE.PlayerBackpack:
		{
			GUIOpenInventory();
		} break;
		
		case GUI_STATE.LootContainer:
		{
			GUIOpenInventory();
			GUIOpenLootContainer();
		} break;
	}
	global.GUIState = _newGUIState;
}

function GUIOpenInventory()
{
	ds_list_add(
		global.ObjWindowHandler.gameWindows,
		new InventoryWindow(
			INVENTORY_TYPE.PlayerBackpack,
			GAME_WINDOW_TYPE.PlayerBackpack,
			new Vector2(0, 0),
			new Size(global.GUIW * 0.4, global.GUIH - 80),
			0, global.PlayerBackpack
		)
	);
}

function GUIOpenLootContainer()
{
	ds_list_add(
		global.ObjWindowHandler.gameWindows,
		new InventoryWindow(
			INVENTORY_TYPE.LootContainer,
			GAME_WINDOW_TYPE.LootContainer,
			new Vector2(global.GUIW * 0.6, 0),
			new Size(global.GUIW * 0.4, global.GUIH - 80),
			0, global.ObjTempInventory.inventory
		)
	);
}
