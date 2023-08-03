function InventoryReloadWeaponGun(_weapon, _magazine)
{
	var reloadedMagazine = _magazine.Clone(1, true);
	
	if (is_undefined(_weapon.metadata.magazine))
	{
		_weapon.metadata.magazine = reloadedMagazine;
		_magazine.sourceInventory.RemoveItemByGridIndex(_magazine.grid_index);
	} else {
		if (_magazine.sourceInventory.ReplaceWithRollback(_magazine, _weapon.metadata.magazine))
		{
			_weapon.metadata.magazine = reloadedMagazine;
		}
	}
}