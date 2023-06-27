function InventoryReloadWeapon(_weapon, _magazine)
{
	var reloadedMagazine = _magazine.Clone();
	reloadedMagazine.sourceInventory = undefined;
	if (reloadedMagazine.is_rotated)
	{
		reloadedMagazine.Rotate();	
	}
	
	if (is_undefined(_weapon.metadata.magazine))
	{
		_weapon.metadata.magazine = reloadedMagazine;
		_magazine.sourceInventory.RemoveItemByGridIndex(_magazine.grid_index);
		
		global.ObjHud.hudElementMagazine.InitMagazine();
	} else {
		if (_magazine.sourceInventory.ReplaceWithRollback(_magazine, _weapon.metadata.magazine))
		{
			_weapon.metadata.magazine = reloadedMagazine;
			
			global.ObjHud.hudElementMagazine.InitMagazine();
		}
	}
}