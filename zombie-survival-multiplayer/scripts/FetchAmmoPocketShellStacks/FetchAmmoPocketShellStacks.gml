function FetchAmmoPocketShellStacks(_weapon, _shellCountToFetch)
{
	var shellStacks = [];
	if (!is_undefined(global.PlayerMagazinePockets))
	{
		var itemCount = ds_list_size(global.PlayerMagazinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMagazinePockets.GetItemByIndex(i);
			if (item.category == "Bullet")
			{
				if (IsReloadingCombatibleWeapon(item, _weapon))
				{
					var shellCountToStack = min(item.quantity, _shellCountToFetch);
					array_push(shellStacks, item);
					_shellCountToFetch -= shellCountToStack;
				}
			}
			
			if (_shellCountToFetch <= 0)
			{
				break;
			}
		}
	}
	return shellStacks;
}