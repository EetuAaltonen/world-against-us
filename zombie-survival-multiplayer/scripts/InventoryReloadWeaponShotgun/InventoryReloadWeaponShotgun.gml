function InventoryReloadWeaponShotgun(_weapon, _ammo)
{
	var reloadCount = min(_ammo.quantity, (_weapon.metadata.shell_capacity - array_length(_weapon.metadata.shells)));
	repeat(reloadCount)
	{
		_weapon.metadata.LoadShell(_ammo.Clone(1));
		_ammo.quantity--;
	}
	if (_ammo.quantity <= 0)
	{
		_ammo.sourceInventory.RemoveItemByGridIndex(_ammo.grid_index);
	}
}