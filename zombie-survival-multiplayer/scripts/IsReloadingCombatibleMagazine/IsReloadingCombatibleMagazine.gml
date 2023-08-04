function IsReloadingCombatibleMagazine(_ammoItem, _magazineItem)
{
	var isCombatible = false;
	
	if (_ammoItem.metadata.caliber == _magazineItem.metadata.caliber)
	{
		isCombatible = true;
	}
	
	return isCombatible;
}