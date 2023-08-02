function InventoryReloadMagazine(_magazine, _ammo)
{
	var reloadCount = min(_ammo.quantity, (_magazine.metadata.GetAmmoCapacity() - _magazine.metadata.GetAmmoCount()));
	repeat(reloadCount)
	{
		_magazine.metadata.ReloadAmmo(_ammo.Clone(1));
		_ammo.quantity--;
	}
	if (_ammo.quantity <= 0)
	{
		_ammo.sourceInventory.RemoveItemByGridIndex(_ammo.grid_index);
	}
}