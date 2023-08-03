function InventoryReloadWeaponFlamethrower(_weapon, _fuelTank)
{
	var reloadedFuelTank = _fuelTank.Clone(1, true);
	if (is_undefined(_weapon.metadata.fuel_tank))
	{
		_weapon.metadata.fuel_tank = reloadedFuelTank;
		_fuelTank.sourceInventory.RemoveItemByGridIndex(_fuelTank.grid_index);
	} else {
		if (_fuelTank.sourceInventory.ReplaceWithRollback(_fuelTank, _weapon.metadata.fuel_tank))
		{
			_weapon.metadata.fuel_tank = reloadedFuelTank;
		}
	}
}