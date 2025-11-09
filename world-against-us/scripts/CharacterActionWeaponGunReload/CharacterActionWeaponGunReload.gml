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
				var magazineRef = InventoryQueryFetchMagazine(backpackRef.metadata.inventory, gunRef)
				if (!is_undefined(magazineRef))
				{
					// SET CHARACTER ACTION
					var activeAnimation = new SkeletalActiveAnimation(
						_instanceRef.sprite_index, CHARACTER_ANIM_RIFLE_RELOAD,
						0, SKELETAL_ANIM_SKIN_UPPERBODY, 1, false, true
					);
					var activeAction = new CharacterActiveAction(
						_instanceRef, CHARACTER_ACTION.RELOAD, activeAnimation,
						undefined, undefined, false, false
					);
					if (_instanceRef.character.action_handler.SetAction(activeAction, false))
					{
						if (is_undefined(gunRef.metadata.magazine))
						{
							gunRef.metadata.magazine = magazineRef.Clone();
							actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED;
						} else {
							var unloadedMagazineIndex = magazineRef.sourceInventory.AddItem(gunRef.metadata.magazine);
							if (!is_undefined(unloadedMagazineIndex))
							{
								gunRef.metadata.magazine = magazineRef.Clone();
								actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED;
							} else {
								actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.FAILED_MAGAZINE_SWAP;
							}
						}
					
						if (actionResult == CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED)
						{
							// REMOVE MAGAZINE FROM INVENTORY ON SUCCESSFUL RELOADING
							magazineRef.sourceInventory.RemoveItemByGridIndex(magazineRef.grid_index);
							_instanceRef.character.gear.has_primary_weapon_magazine = true;
						}
					} else {
						actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.ACTION_FAILED;
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