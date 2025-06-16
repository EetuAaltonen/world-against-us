function MetadataItemBackpack(_inventory_size, _max_weight_capacity) : Metadata() constructor
{
    inventory_size = _inventory_size;
	max_weight_capacity = _max_weight_capacity;
	inventory = undefined;
	is_initialized = false;
	
	static Initialize = function(_inventoryId, _inventoryType, _inventoryFilter, _itemLimit, _items = [])
	{
		if (!is_initialized)
		{
			inventory = new Inventory(_inventoryId, _inventoryType, inventory_size, _inventoryFilter, _itemLimit);
			inventory.AddMultipleItems(_items);
			is_initialized = true;
		}
	}
	
	static ToJSONStruct = function()
	{
		var formatInventory = (!is_undefined(inventory)) ? inventory.ToJSONStruct() : undefined;
		return {
			inventory_content: formatInventory
		}
	}
}