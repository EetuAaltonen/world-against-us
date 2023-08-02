function FetchAmmoPocketShellStack(_caliber, _shellCountToFetch)
{
	var foundShellStack = undefined;
	if (!is_undefined(global.PlayerAmmoPockets))
	{
		var itemCount = ds_list_size(global.PlayerAmmoPockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerAmmoPockets.GetItemByIndex(i);
			if (item.category == "Bullet" && item.type == "Shotgun Shell")
			{
				if (item.metadata.caliber == _caliber)
				{
					if (!is_undefined(foundShellStack))
					{
						var shellCountToStack = min(item.quantity, (_shellCountToFetch - foundShellStack.quantity))
						if (shellCountToStack > 0)
						{
							foundShellStack.quantity += shellCountToStack;
							item.quantity -= shellCountToStack;
							
							if (item.quantity <= 0)
							{
								item.sourceInventory.RemoveItemByGridIndex(item.grid_index);
							}
						}
					} else {
						foundShellStack = item;
					}
				}
			}
			
			if (!is_undefined(foundShellStack))
			{
				if (foundShellStack.quantity >= _shellCountToFetch)
				{
					break;
				}
			}
		}
	}
	return foundShellStack;
}