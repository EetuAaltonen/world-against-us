function FetchAmmoPocketMagazine(_weapon)
{
	var foundMagazine = undefined;
	if (!is_undefined(global.PlayerMagazinePockets))
	{
		var itemCount = ds_list_size(global.PlayerMagazinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMagazinePockets.GetItemByIndex(i);
			if (item.category == "Magazine")
			{
				if (IsReloadingCombatibleWeapon(item, _weapon))
				{
					if (!is_undefined(foundMagazine))
					{
						if (item.metadata.GetAmmoCount() > foundMagazine.metadata.GetAmmoCount())
						{
							foundMagazine = item;
						} else if (item.metadata.GetAmmoCount() == foundMagazine.metadata.GetAmmoCount())
						{
							if (item.grid_index.col < foundMagazine.grid_index.col)
							{
								foundMagazine = item;
							} else if (item.grid_index.col == foundMagazine.grid_index.col)
							{
								if (item.grid_index.row < foundMagazine.grid_index.row)
								{
									foundMagazine = item;
								}
							}
						}
					} else {
						if (item.metadata.GetAmmoCount() > 0)
						{
							foundMagazine = item;
						}
					}
				}
			}
		}
	}
	return foundMagazine;
}