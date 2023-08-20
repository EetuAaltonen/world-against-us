function CallbackItemSlotPlayerBackpack(_item)
{
	if (!is_undefined(_item))
	{
		if (!is_undefined(_item.metadata))
		{
			global.PlayerBackpack = _item.metadata.inventory;
		}
	} else {
		global.PlayerBackpack = undefined;
	}
}