function InventoryQueryFetchMagazine(_inventoryRef, _gunRef)
{
	var magazine = undefined;
	var magazineBulletCount = 0;
	var itemCount = _inventoryRef.GetItemCount();
	for (var i = 0; i < itemCount; i++)
	{
		var item = _inventoryRef.GetItemByIndex(i);
		if (!is_undefined(item))
		{
			if (item.category == _gunRef.metadata.chamber_type &&
				item.type == _gunRef.type)
			{
				if (item.metadata.caliber == _gunRef.metadata.caliber)
				{
					var bulletCount = array_length(item.metadata.bullets);
					if (bulletCount > 0)
					{
						if (is_undefined(magazine) || bulletCount > magazineBulletCount)
						{
							magazine = item;
							magazineBulletCount = bulletCount;
						}
					}
				}
			}
		}
	}
	return magazine;
}