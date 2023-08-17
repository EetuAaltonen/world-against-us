/// @description Custom RoomStartEvent
if (is_undefined(inventory))
{
	if (!is_undefined(containerId))
	{
		// INITIALIZE INVENTORY
		inventory = new Inventory(containerId, INVENTORY_TYPE.LootContainer);
		
		// CHECK IF CONTAINER HAS ROOM SAVE RECORD
		var items = global.GameSaveHandlerRef.GetContainerContentById(containerId);
		if (!is_undefined(items))
		{
			var itemCount = array_length(items);
			for (var i = 0; i < itemCount; i++)
			{
				var item = items[@ i];
				var addedItemGridIndex = inventory.AddItem(item, item.grid_index, item.is_rotated, item.is_known);
				if (is_undefined(addedItemGridIndex)) break;
			}
		
			isContainerSearched = true;
		}
	} else {
		throw (string("Object {0} with instance ID {1} is missing 'containerId'", object_get_name(object_index), id));	
	}
}