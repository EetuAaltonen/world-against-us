if (!is_undefined(structure))
{
	if (!is_undefined(structure.metadata))
	{
		if (
			structure.metadata.tools_inventory.GetItemCount() == 1 &&
			structure.metadata.fertilizer_inventory.GetItemCount() == 1 &&
			structure.metadata.water_inventory.GetItemCount() == 1 &&
			structure.metadata.seed_inventory.GetItemCount() == 1
		)
		{
			var outputFood = global.ItemDatabase.GetItemByName("Tomato");
			if (!is_undefined(outputFood))
			{
				var seedPack = structure.metadata.seed_inventory.GetItemByIndex(0);
				if (!is_undefined(seedPack))
				{
					repeat(seedPack.quantity)
					{
						var outputItemGridIndex = structure.metadata.output_inventory.AddItem(outputFood.Clone());
						if (is_undefined(outputItemGridIndex)) break;
					}
					structure.metadata.seed_inventory.RemoveItemByGridIndex(seedPack.grid_index);
				}
			}
		}
	}
}