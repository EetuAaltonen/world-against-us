function DatabaseItem() constructor
{
	itemData = ds_map_create();
	
	static GetItemByName = function(_name, _quantity = 1)
	{
		var itemClone = itemData[? _name].Clone();
		if (!is_undefined(itemClone))
		{
			itemClone.quantity = _quantity
		}
		
		return itemClone;
	}
	
	static GetItemNames = function()
	{
		return ds_map_keys_to_array(itemData);
	}
}