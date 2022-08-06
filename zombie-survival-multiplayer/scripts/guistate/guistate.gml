function IsGUIStateClosed() {
	return (global.GUIState == GUI_STATE.Noone);
}

function RequestGUIState(_newGUIState)
{
	var guiChangeSuccess = true;
	
	if (_newGUIState == global.GUIState) { return guiChangeSuccess; }
	
	global.GUIState = _newGUIState;
	CloseGUIWindows();
	
	switch (_newGUIState)
	{
		case GUI_STATE.PlayerBackpack:
		{
			SetBackpackShow(true);
		} break;
		case GUI_STATE.LootContainer:
		{
			// Set loot from container
			SetBackpackShow(true);
		} break;
		default:
		{
			global.GUIState = GUI_STATE.Noone;
		}
	}
	
	return guiChangeSuccess;
}

function CloseGUIWindows()
{
	SetBackpackShow(false);
	SetLootContainer(noone);
}

function SetBackpackShow(_show)
{
	if (global.PlayerBackpack != noone)
	{
		with (global.PlayerBackpack)
		{
			showInventory = _show;	
		}
	}
}

function SetLootContainer(_loot)
{
	if (global.ObjLootContainer != noone)
	{
		with (global.ObjLootContainer)
		{
			loot = _loot;
			if (loot != noone)
			{
				with (loot)
				{
					showInventory = true;
				}
			}
		}
	}
}
