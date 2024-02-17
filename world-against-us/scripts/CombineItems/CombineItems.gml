function CombineItems(_sourceItem, _targetItem, _only_compatibility = false)
{
	var isCombined = false;
	var combineAction = undefined;
	
	// STACK ITEMS
	if (_targetItem.Compare(_sourceItem))
	{
		if (_only_compatibility)
		{
			if (_targetItem.quantity < _targetItem.max_stack)
			{
				isCombined = true;
			}
		} else {
			_targetItem.Stack(_sourceItem);
			isCombined = (_sourceItem.quantity <= 0);
		}
	// RELOAD WEAPON
	} else {
		switch (_sourceItem.category)
		{
			case "Bullet":
			{
				if (_targetItem.category == "Magazine")
				{
					if (IsReloadingCombatibleMagazine(_sourceItem, _targetItem))
					{
						combineAction = InventoryReloadMagazine;
						isCombined = true;
					}
				} else if (_targetItem.category == "Weapon" && _targetItem.type == "Shotgun")
				{
					if (_targetItem.metadata.chamber_type == "Shell")
					{
						if (IsReloadingCombatibleWeapon(_sourceItem, _targetItem))
						{
							combineAction = InventoryReloadWeaponShotgun;
							isCombined = true;
						}
					}
				}
			} break;
			case "Magazine":
			{
				if (_targetItem.category == "Weapon" && _targetItem.type != "Melee")
				{
					if (IsReloadingCombatibleWeapon(_sourceItem, _targetItem))
					{
						combineAction = InventoryReloadWeaponGun;
						isCombined = true;
					}
				}
			} break;
			case "Fuel Ammo":
			{
				if (_targetItem.category == "Weapon" && _targetItem.type == "Flamethrower")
				{
					if (IsReloadingCombatibleWeapon(_sourceItem, _targetItem))
					{
						combineAction = InventoryReloadWeaponFlamethrower;
						isCombined = true;
					}
				}
			} break;
		}
	}
	
	if (!_only_compatibility)
	{
		if (!is_undefined(combineAction))
		{
			isCombined = combineAction(_targetItem, _sourceItem);
		}
	}
	
	return isCombined;
}