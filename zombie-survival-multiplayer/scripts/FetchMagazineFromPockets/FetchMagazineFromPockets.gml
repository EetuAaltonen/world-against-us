function FetchMagazineFromPockets(_caliber)
{
	var foundMagazine = undefined;
	if (!is_undefined(global.PlayerMagazinePockets))
	{
		var itemCount = ds_list_size(global.PlayerMagazinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMagazinePockets.GetItemByIndex(i);
			if (item.type == "Magazine")
			{
				if (item.metadata.caliber == _caliber)
				{
					if (!is_undefined(foundMagazine))
					{
						if (item.metadata.bullet_count > foundMagazine.metadata.bullet_count)
						{
							foundMagazine = item;
						} else if (item.metadata.bullet_count == foundMagazine.metadata.bullet_count)
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
						if (item.metadata.bullet_count > 0)
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