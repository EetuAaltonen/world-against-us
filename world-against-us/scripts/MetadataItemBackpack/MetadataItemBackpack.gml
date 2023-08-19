function MetadataItemBackpack(_inventory_size, _max_weight_capacity) : Metadata() constructor
{
    inventory_size = _inventory_size;
	max_weight_capacity = _max_weight_capacity;
	
	inventory = undefined;
	
	static ToJSONStruct = function()
	{
		var formatInventory = (!is_undefined(inventory)) ? inventory.ToJSONStruct() : undefined;
		return {
			inventory_content: formatInventory
		}
	}
	
	static InitInventory = function(_inventoryId, _inventoryType = INVENTORY_TYPE.BackpackSlot)
	{
		inventory = new Inventory(_inventoryId, _inventoryType, inventory_size, []);
	}
}