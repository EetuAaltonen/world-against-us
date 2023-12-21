function NetworkInventoryStreamItems(_region_id, _inventory_id, _items) constructor
{
	region_id = _region_id;
    inventory_id = _inventory_id;
    items = _items;
	
	static ToJSONStruct = function()
	{
		var formatItems = FormatItemListToJSONArray(items);
		return {
			region_id: region_id,
			inventory_id: inventory_id,
			items: formatItems,
		}
	}
}