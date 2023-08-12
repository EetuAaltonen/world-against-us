if (
	toolsInventory.GetItemCount() == 1 &&
	fertilizeInventory.GetItemCount() == 1 &&
	waterInventory.GetItemCount() == 1 &&
	seedInventory.GetItemCount() == 1
)
{
	var outputFood = global.ItemDatabase.GetItemByName("Tomato");
	if (!is_undefined(outputFood))
	{
		var seedPack = seedInventory.GetItemByIndex(0);
		if (!is_undefined(seedPack))
		{
			repeat(seedPack.quantity)
			{
				var outputItemGridIndex = outputInventory.AddItem(outputFood.Clone());
				if (is_undefined(outputItemGridIndex)) break;
			}
			seedInventory.RemoveItemByGridIndex(seedPack.grid_index);
		}
	}
}