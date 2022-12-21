function FetchMedicineFromPockets()
{
	var foundMedicine = undefined;
	if (!is_undefined(global.PlayerMedicinePockets))
	{
		var itemCount = ds_list_size(global.PlayerMedicinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMedicinePockets.GetItemByIndex(i);
			if (item.type == "Medicine")
			{
				if (!is_undefined(foundMedicine))
				{
					if (item.grid_index.col < foundMedicine.grid_index.col)
					{
						foundMedicine = item;
					} else if (item.grid_index.col == foundMedicine.grid_index.col)
					{
						if (item.grid_index.row < foundMedicine.grid_index.row)
						{
							foundMedicine = item;
						}
					}
				} else {
					foundMedicine = item;
				}
			}
		}
	}
	return foundMedicine;
}