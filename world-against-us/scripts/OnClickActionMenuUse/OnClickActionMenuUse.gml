function OnClickActionMenuUse()
{
	var item = parentElement.targetItem;
	switch (item.category)
	{
		case "Weapon": { ItemActionUsePrimaryWeapon(item); } break;
		case "Consumable": { ItemActionUseConsumable(item); } break;
		case "Medicine": { ItemActionUseMedicine(item); } break;
	}
	
	// CLOSE ACTION MENU
	global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
}