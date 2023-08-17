function InventoryReloadMagazine(_magazine, _ammo)
{
	var isAmmoReloaded = false;
	var reloadCount = min(_ammo.quantity, (_magazine.metadata.GetAmmoCapacity() - _magazine.metadata.GetAmmoCount()));
	
	repeat(reloadCount)
	{
		_magazine.metadata.ReloadAmmo(_ammo.Clone(1, true));
		_ammo.quantity--;
	}
	if (_ammo.quantity <= 0)
	{
		isAmmoReloaded = true;
	}
	
	return isAmmoReloaded;
}