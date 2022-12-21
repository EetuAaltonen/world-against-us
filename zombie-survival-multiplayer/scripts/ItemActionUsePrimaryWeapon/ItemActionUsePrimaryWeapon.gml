function ItemActionUsePrimaryWeapon(_item)
{
	if (_item.sourceInventory.type == INVENTORY_TYPE.PlayerBackpack)
	{
		if (global.ObjWeapon != noone)
		{
			if (!_item.Compare(global.ObjWeapon.primaryWeapon))
			{
				global.ObjWeapon.primaryWeapon = _item;
				global.ObjWeapon.initWeapon = true;
			}
		}
	}
}