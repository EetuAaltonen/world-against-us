function ItemActionUnloadWeapon(_weapon)
{
	if (_weapon.type != "Melee")
	{
		switch (_weapon.metadata.chamber_type)
		{
			case "Fuel Tank": {
				if (!is_undefined(_weapon.metadata.fuel_tank))
				{
					var unloadedFuelGridIndex = _weapon.sourceInventory.AddItem(_weapon.metadata.fuel_tank, undefined, false);
					if (!is_undefined(unloadedFuelGridIndex))
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
					var unloadedShellGridIndex = _weapon.sourceInventory.AddItem(shell, undefined, false);
					if (is_undefined(unloadedShellGridIndex))
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
					var unloadedMagazineGridIndex = _weapon.sourceInventory.AddItem(_weapon.metadata.magazine, undefined, false);
					if (!is_undefined(unloadedMagazineGridIndex))
					{
						_weapon.metadata.magazine = undefined;
					}
				}
			} break;
		}
	}
}