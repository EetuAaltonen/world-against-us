function ItemActionUnloadMagazine(_item)
{
	var bulletCountToUnload = _item.metadata.GetAmmoCount();
	repeat(bulletCountToUnload)
	{
		var bullet = _item.metadata.UnloadAmmo();
		var unloadedBulletGridIndex = _item.sourceInventory.AddItem(bullet.Clone(), undefined, true, true);
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