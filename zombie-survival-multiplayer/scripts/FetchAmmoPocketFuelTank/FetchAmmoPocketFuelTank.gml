function FetchAmmoPocketFuelTank(_weapon)
{
	var foundFuelTank = undefined;
	if (!is_undefined(global.PlayerAmmoPockets))
	{
		var itemCount = ds_list_size(global.PlayerAmmoPockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerAmmoPockets.GetItemByIndex(i);
			if (item.category == "Fuel Ammo")
			{
				if (IsReloadingCombatibleWeapon(item, _weapon))
				{
					if (!is_undefined(foundFuelTank))
					{
						if (item.metadata.GetAmmoCount() > foundFuelTank.metadata.GetAmmoCount())
						{
							foundFuelTank = item;
						} else if (item.metadata.GetAmmoCount() == foundFuelTank.metadata.GetAmmoCount())
						{
							if (item.grid_index.col < foundFuelTank.grid_index.col)
							{
								foundFuelTank = item;
							} else if (item.grid_index.col == foundFuelTank.grid_index.col)
							{
								if (item.grid_index.row < foundFuelTank.grid_index.row)
								{
									foundFuelTank = item;
								}
							}
						}
					} else {
						if (item.metadata.GetAmmoCount() > 0)
						{
							foundFuelTank = item;
						}
					}
				}
			}
		}
	}
	return foundFuelTank;
}