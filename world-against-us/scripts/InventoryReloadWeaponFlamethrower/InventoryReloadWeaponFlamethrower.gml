function InventoryReloadWeaponFlamethrower(_weapon, _fuelTank)
{
	var isFuelTankReloaded = false;
	var reloadedFuelTank = _fuelTank.Clone(1, true);
	
	if (is_undefined(_weapon.metadata.fuel_tank))
	{
		_weapon.metadata.fuel_tank = reloadedFuelTank;
		isFuelTankReloaded = true;
	} else {
		var unloadedFuelGridIndex = _fuelTank.sourceInventory.AddItem(_weapon.metadata.fuel_tank);
		if (!is_undefined(unloadedFuelGridIndex))
		{
			_weapon.metadata.magazine = reloadedFuelTank;
			isFuelTankReloaded = true;
		}
	}
	
	return isFuelTankReloaded;
}