function FetchAmmoPocketShellStack(_weapon, _shellCountToFetch)
{
	var foundShellStack = undefined;
	if (!is_undefined(global.PlayerAmmoPockets))
	{
		var itemCount = ds_list_size(global.PlayerAmmoPockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerAmmoPockets.GetItemByIndex(i);
			if (item.category == "Bullet")
			{
				if (IsReloadingCombatibleWeapon(item, _weapon))
				{
					if (!is_undefined(foundShellStack))
					{
						var shellCountToStack = min(item.quantity, (_shellCountToFetch - foundShellStack.quantity))
						if (shellCountToStack > 0)
						{
							// TODO: Don't stack the same type of shells to the same stack
							// Repeat and return every type of shell stacks separately or call Reload function
							foundShellStack.quantity += shellCountToStack;
							item.quantity -= shellCountToStack;
							
							if (item.quantity <= 0)
							{
								item.sourceInventory.RemoveItemByIndex(i);
								
								// UPDATE ITEM COUNT AND INDEX AFTER DELETING
								itemCount = ds_list_size(global.PlayerAmmoPockets.items);
								i--;
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