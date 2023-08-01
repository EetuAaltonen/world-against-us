function InventoryReloadWeaponGun(_weapon, _ammo)
{
	var reloadedMagazine = _ammo.Clone();
	reloadedMagazine.sourceInventory = undefined;
	if (reloadedMagazine.is_rotated)
	{
		reloadedMagazine.Rotate();	
	}
	
	if (is_undefined(_weapon.metadata.magazine))
	{
		_weapon.metadata.magazine = reloadedMagazine;
		_ammo.sourceInventory.RemoveItemByGridIndex(_ammo.grid_index);
		
		global.ObjHud.hudElementMagazine.InitAmmo();
	} else {
		if (_ammo.sourceInventory.ReplaceWithRollback(_ammo, _weapon.metadata.magazine))
		{
			_weapon.metadata.magazine = reloadedMagazine;

			global.ObjHud.hudElementMagazine.InitAmmo();
		}
	}
}