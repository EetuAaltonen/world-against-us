function IsReloadingCombatibleWeapon(_ammoItem, _weaponItem)
{
	var isCombatible = false;
	
	if (_ammoItem.type == _weaponItem.type || _ammoItem.type == _weaponItem.name)
	{
		if (_ammoItem.metadata.caliber == _weaponItem.metadata.caliber)
		{
			isCombatible = true;
		}
	}
	
	return isCombatible;
}