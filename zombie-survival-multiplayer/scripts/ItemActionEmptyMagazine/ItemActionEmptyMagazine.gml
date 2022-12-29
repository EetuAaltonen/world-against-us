function ItemActionEmptyMagazine(_item)
{
	var bulletCountToUnload = _item.metadata.bullet_count;
	if (bulletCountToUnload > 0)
	{
		if (_item.sourceInventory.AddItem(global.ItemData[? string("{0} Bullet", _item.metadata.caliber)].Clone(bulletCountToUnload), undefined, true, true))
		{
			_item.metadata.bullet_count = 0;
		} else {
			// MESSAGE LOG
			AddMessageLog(string("Couldn't unload {0}", _item.name));
		}
	}
}