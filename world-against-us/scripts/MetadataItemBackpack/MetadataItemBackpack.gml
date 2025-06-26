function MetadataItemBackpack(_inventory_size, _max_weight_capacity) : Metadata() constructor
{
	inventory_size = _inventory_size;
	max_weight_capacity = _max_weight_capacity;
	inventory = undefined;
	is_initialized = false;
	
	static ToJSONStruct = function()
	{
		var formatInventory = (!is_undefined(inventory)) ? inventory.ToJSONStruct() : undefined;
		return {
			inventory: formatInventory
		}
	}
	
	static Clone = function()
	{
		var clone = new MetadataItemBackpack(
			inventory_size,
			max_weight_capacity
		);
		if (is_initialized)
		{
			var cloneInventory = inventory.Clone();
			clone.Initialize(cloneInventory);
		}
		return clone;
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.inventory);
		_struct.inventory = undefined;
		
	}
	
	static Initialize = function(_inventory)
	{
		if (!is_initialized)
		{
			inventory = _inventory;
			is_initialized = true;
		}
	}
}