function ItemActionUnloadMagazine(_item)
{
	var targetInventory = (_item.sourceInventory.type == INVENTORY_TYPE.PlayerBackpack) ? _item.sourceInventory : global.PlayerBackpack;
	var bulletCountToUnload = _item.metadata.GetAmmoCount();
	repeat(bulletCountToUnload)
	{
		var bulletName = _item.metadata.UnloadAmmo();
		var bulletData = global.ItemDatabase.GetItemByName(bulletName);
		var unloadedBulletGridIndex = targetInventory.AddItem(bulletData, undefined, true, true);
		if (is_undefined(unloadedBulletGridIndex))
		{
			// REVERSE UNLOAD IF DOESN'T FIT
			_item.metadata.ReloadAmmo(bullet.Clone());
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					string("Couldn't unload {0}", _item.name),
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
			break;
		}
	}
}