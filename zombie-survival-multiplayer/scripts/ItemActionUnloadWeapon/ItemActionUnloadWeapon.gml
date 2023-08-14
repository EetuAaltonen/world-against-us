function ItemActionUnloadWeapon(_weapon)
{
	if (_weapon.type != "Melee")
	{
		var targetInventory = (_weapon.sourceInventory.type == INVENTORY_TYPE.PlayerBackpack) ? _weapon.sourceInventory : global.PlayerBackpack;
		switch (_weapon.metadata.chamber_type)
		{
			case "Fuel Tank": {
				if (!is_undefined(_weapon.metadata.fuel_tank))
				{
					var unloadedFuelGridIndex = targetInventory.AddItem(_weapon.metadata.fuel_tank, undefined, false);
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
					var unloadedShellGridIndex = targetInventory.AddItem(shell, undefined, false);
					if (is_undefined(unloadedShellGridIndex))
					{
						// REVERSE UNLOAD IF DOESN'T FIT
						_weapon.metadata.ReloadAmmo(shell);
						// LOG NOTIFICATION
						global.NotificationHandlerRef.AddNotification(
							new Notification(
								undefined,
								string("Couldn't unload {0}", _weapon.name),
								undefined,
								NOTIFICATION_TYPE.Log
							)
						);
						break;
					}
				}
			} break;
			default: {
				if (!is_undefined(_weapon.metadata.magazine))
				{
					var unloadedMagazineGridIndex = targetInventory.AddItem(_weapon.metadata.magazine, undefined, false);
					if (!is_undefined(unloadedMagazineGridIndex))
					{
						_weapon.metadata.magazine = undefined;
					}
				}
			} break;
		}
		
		// UPDATE HUD ELEMENT FOR AMMO
		global.ObjHud.hudElementAmmo.initAmmo = true;
	}
}