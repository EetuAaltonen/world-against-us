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
			if (_sourceItem.quantity <= 0)
			{
				isCombined = true;
			}
		}
	// RELOAD WEAPON
	} else {
		switch (_sourceItem.category)
		{
			case "Bullet":
			{
				if (_targetItem.category == "Magazine")
				{
					if (_targetItem.metadata.caliber == _sourceItem.metadata.caliber)
					{
						combineAction = InventoryReloadMagazine;
						isCombined = true;
					}
				} else if (_targetItem.category == "Weapon" && _targetItem.type == "Shotgun")
				{
					if (_targetItem.metadata.chamber_type == "Shell")
					{
						if (_sourceItem.type == "Shotgun Shell")
						{
							if (_targetItem.metadata.caliber == _sourceItem.metadata.caliber)
							{
								combineAction = InventoryReloadWeaponShotgun;
								isCombined = true;
							}
						}
					}
				}
			} break;
			case "Magazine":
			{
				if (_targetItem.category == "Weapon" && _targetItem.type != "Melee")
				{
					if (_targetItem.metadata.caliber == _sourceItem.metadata.caliber)
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
					if (_targetItem.metadata.caliber == _sourceItem.metadata.caliber)
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