function OnClickActionMenuEmpty()
{
	var item = parentElement.targetItem;
	switch (item.category)
	{
		case "Weapon": { ItemActionEmptyPrimaryWeapon(item); } break;
		case "Magazine": { ItemActionEmptyMagazine(item); } break;
	}
	
	// CLOSE ACTION MENU
	global.GUIStateHandlerRef.CloseCurrentGUIState();
}