function ItemActionUnloadWeapon(_weapon)
{
	if (_weapon.type != "Melee")
	{
		switch (_weapon.metadata.chamber_type)
		{
			case "Fuel Tank": {
				if (!is_undefined(_weapon.metadata.fuel_tank))
				{
					if (_weapon.sourceInventory.AddItem(_weapon.metadata.fuel_tank, undefined, false))
					{
						_weapon.metadata.fuel_tank = undefined;
					}
				}
			} break;
			case "Shell": {
				var shellCountToUnload = _weapon.metadata.GetAmmoCount();
				repeat (shellCountToUnload)
				{
					var shell = _weapon.metadata.UnloadAmmo();
					if (!_weapon.sourceInventory.AddItem(shell, undefined, false))
					{
						// REVERSE UNLOAD IF DOESN'T FIT
						_weapon.metadata.ReloadAmmo(shell);
						// MESSAGE LOG
						AddMessageLog(string("Couldn't unload {0}", _weapon.name));
						break;
					}
				}
			} break;
			default: {
				if (!is_undefined(_weapon.metadata.magazine))
				{
					if (_weapon.sourceInventory.AddItem(_weapon.metadata.magazine, undefined, false))
					{
						_weapon.metadata.magazine = undefined;
					}
				}
			} break;
		}
	}
}