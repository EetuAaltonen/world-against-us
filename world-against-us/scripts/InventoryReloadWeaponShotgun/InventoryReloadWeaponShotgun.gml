function InventoryReloadWeaponShotgun(_weapon, _shellStack)
{
	var isShellStackReloaded = false;
	var reloadCount = min(_shellStack.quantity, (_weapon.metadata.GetAmmoCapacity() - _weapon.metadata.GetAmmoCount()));
	
	repeat(reloadCount)
	{
		_weapon.metadata.ReloadAmmo(_shellStack.Clone(1, true));
		_shellStack.quantity--;
	}
	if (_shellStack.quantity <= 0)
	{
		isShellStackReloaded = true;
	}
	
	return isShellStackReloaded;
}