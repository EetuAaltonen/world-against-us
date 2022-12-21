function OnClickActionMenuEmpty()
{
	var item = parentElement.targetItem;
	switch (item.type)
	{
		case "Primary_Weapon": { ItemActionEmptyPrimaryWeapon(item); } break;
		case "Magazine": { ItemActionEmptyMagazine(item); } break;
	}
	
	// CLOSE ACTION MENU
	global.GUIStateHandler.CloseCurrentGUIState();
}