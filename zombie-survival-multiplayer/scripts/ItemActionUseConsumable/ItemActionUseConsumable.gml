function ItemActionUseConsumable(_item)
{
	if (_item.metadata.consumable_type == "Food")
	{
		global.ObjPlayer.character.EatItem(_item);
	} else if (_item.metadata.consumable_type == "Liquid")
	{
		global.ObjPlayer.character.DrinkItem(_item);
	}
}