function DatabaseItem() constructor
{
	itemData = ds_map_create();
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.itemData, ds_type_map);
		_struct.itemData = undefined;
	}
	
	static GetItemByName = function(_name, _quantity = 1)
	{
		var itemClone = itemData[? _name].Clone();
		if (!is_undefined(itemClone))
		{
			itemClone.quantity = _quantity
		}
		
		return itemClone;
	}
}