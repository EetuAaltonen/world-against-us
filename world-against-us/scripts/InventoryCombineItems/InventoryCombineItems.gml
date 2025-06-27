function InventoryCombineItems(_sourceItem, _targetItem, _only_compatibility = false)
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
					if (_sourceItem.metadata.caliber == _targetItem.metadata.caliber)
					{
						combineAction = InventoryReloadMagazine;
						isCombined = true;
					}
				}
				// TODO: Fix reloading shotguns
			} break;
			case "Magazine":
			{
				if (_targetItem.category == "Weapon" && _targetItem.type != "Melee")
				{
					if (_sourceItem.metadata.caliber == _targetItem.metadata.caliber)
					{
						if (_sourceItem.type == _targetItem.type)
						{
							combineAction = InventoryReloadWeaponGun;
							isCombined = true;
						}
					}
				}
			} break;
			case "Fuel Ammo":
			{
				// TODO: Fix reloading flamethrower
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