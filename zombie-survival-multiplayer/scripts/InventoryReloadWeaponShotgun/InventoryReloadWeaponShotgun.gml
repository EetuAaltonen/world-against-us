function InventoryReloadWeaponShotgun(_weapon, _shell)
{
	var reloadCount = min(_shell.quantity, (_weapon.metadata.GetAmmoCapacity() - _weapon.metadata.GetAmmoCount()));
	repeat(reloadCount)
	{
		_weapon.metadata.ReloadAmmo(_shell.Clone(1));
		_shell.quantity--;
	}
	if (_shell.quantity <= 0)
	{
		_shell.sourceInventory.RemoveItemByGridIndex(_shell.grid_index);
	}
}