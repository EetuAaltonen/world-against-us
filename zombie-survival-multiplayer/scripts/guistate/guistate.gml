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
			GUIOpenPlayerBackpack();
		} break;
		
		case GUI_STATE.LootContainer:
		{
			GUIOpenPlayerBackpack();
			GUIOpenLootContainer();
		} break;
	}
	global.GUIState = _newGUIState;
}
