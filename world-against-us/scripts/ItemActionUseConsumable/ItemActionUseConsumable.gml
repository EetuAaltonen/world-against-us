function ItemActionUseConsumable(_item)
{
	if (_item.metadata.consumable_type == "Food")
	{
		global.InstancePlayer.character.EatItem(_item);
	} else if (_item.metadata.consumable_type == "Liquid")
	{
		global.InstancePlayer.character.DrinkItem(_item);
	}
}