function InventoryReloadWeaponGun(_weapon, _magazine)
{
	var isMagazineReloaded = false;
	var reloadedMagazine = _magazine.Clone(1, true);
	
	if (is_undefined(_weapon.metadata.magazine))
	{
		_weapon.metadata.magazine = reloadedMagazine;
		isMagazineReloaded = true;
	} else {
		var unloadedMagazineGridIndex = _magazine.sourceInventory.AddItem(_weapon.metadata.magazine);
		if (!is_undefined(unloadedMagazineGridIndex))
		{
			_weapon.metadata.magazine = reloadedMagazine;
			isMagazineReloaded = true;
		}
	}
	
	return isMagazineReloaded;
}