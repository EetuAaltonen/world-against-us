function NetworkInventoryStreamItems(_items) constructor
{
	// PRIOR FORMATTED JSON ITEMS
	items = _items;
	
	static ToJSONStruct = function()
	{
		return {
			items: items
		}
	}
}