function CharacterActionWeaponGunReload(_instanceRef)
{
	var actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED;
	var gunRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.primary_weapon);
	if (is_undefined(gunRef)) return CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.MISSING_GUN;
	
	var backpackRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.backpack);
	if (!is_undefined(backpackRef))
	{
		switch (gunRef.metadata.chamber_type)
		{
			case "Magazine": {
				var magazine = InventoryQueryFetchMagazine(backpackRef.metadata.inventory, gunRef)
				if (!is_undefined(magazine))
				{
					if (is_undefined(gunRef.metadata.magazine))
					{
						gunRef.metadata.magazine = magazine.Clone();
						actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED;
					} else {
						var unloadedMagazineIndex = magazine.sourceInventory.AddItem(gunRef.metadata.magazine);
						if (!is_undefined(unloadedMagazineIndex))
						{
							gunRef.metadata.magazine = magazine.Clone();
							actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED;
						} else {
							actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.FAILED_MAGAZINE_SWAP;
						}
					}
					// REMOVE MAGAZINE FROM INVENTORY ON SUCCESSFUL RELOADING
					if (actionResult == CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED)
					{
						magazine.sourceInventory.RemoveItemByGridIndex(magazine.grid_index);
						 _instanceRef.character.gear.has_primary_weapon_magazine = true;
						 
						 // SET CHARACTER ACTION
						_instanceRef.character.action_handler.SetAction(
							CHARACTER_ACTION.RELOAD, false,
							undefined, 1000, false
						);
					}
				} else {
					actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.MISSING_REPLACEMENT_MAGAZINE;
				}
			} break;
		}
	} else {
		actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.MISSING_REPLACEMENT_MAGAZINE;
	}
	return actionResult;
}