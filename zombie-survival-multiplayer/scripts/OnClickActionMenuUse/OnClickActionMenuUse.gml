function OnClickActionMenuUse()
{
	var item = parentElement.targetItem;
	switch (item.type)
	{
		case "Primary_Weapon": { ItemActionUsePrimaryWeapon(item); } break;
		case "Consumable": { ItemActionUseConsumable(item); } break;
		case "Medicine": { ItemActionUseMedicine(item); } break;
	}
	
	// CLOSE ACTION MENU
	global.GUIStateHandlerRef.CloseCurrentGUIState();
}