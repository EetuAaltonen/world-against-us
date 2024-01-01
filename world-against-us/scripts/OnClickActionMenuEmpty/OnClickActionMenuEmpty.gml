function OnClickActionMenuEmpty()
{
	var item = parentElement.targetItem;
	switch (item.category)
	{
		case "Weapon": { ItemActionUnloadWeapon(item); } break;
		case "Magazine": { ItemActionUnloadMagazine(item); } break;
	}
	
	// CLOSE ACTION MENU
	global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
}