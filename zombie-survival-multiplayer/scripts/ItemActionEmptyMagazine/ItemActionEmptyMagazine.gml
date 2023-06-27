function ItemActionEmptyMagazine(_item)
{
	var bulletCountToUnload = _item.metadata.GetBulletCount();
	if (bulletCountToUnload > 0)
	{
		repeat(bulletCountToUnload)
		{
			var bullet = _item.metadata.UnloadBullet();
			if (!_item.sourceInventory.AddItem(bullet.Clone(1), undefined, true, true))
			{
				// REVERSE UNLOAD IF DOESN'T NOT FIT
				_item.metadata.LoadBullet(bullet.Clone(1));
				// MESSAGE LOG
				AddMessageLog(string("Couldn't unload {0}", _item.name));
				break;
			}
		}
	}
}