function InventoryReloadWeapon(_weapon, _magazine)
{
	// SET ROTATION TO DEFAULT
	if (_magazine.is_rotated)
	{
		_magazine.Rotate();	
	}
	
	if (is_undefined(_weapon.metadata.magazine))
	{
		_magazine.sourceInventory.RemoveItemByGridIndex(_magazine.grid_index);
		_weapon.metadata.magazine = _magazine;
	} else {
		if (_magazine.sourceInventory.ReplaceWithRollback(_magazine, _weapon.metadata.magazine))
		{
			_weapon.metadata.magazine = _magazine;
		}
	}
}