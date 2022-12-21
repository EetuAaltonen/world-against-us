function ItemActionEmptyPrimaryWeapon(_item)
{
	if (_item.sourceInventory.AddItem(_item.metadata.magazine))
	{
		_item.metadata.magazine = undefined;
	}
}