/// @description Custom RoomStartEvent
if (is_undefined(inventory))
{
	if (!is_undefined(containerId))
	{
		// INITIALIZE INVENTORY
		var inventorySize = new InventorySize(10, 12);
		inventory = new Inventory(containerId, INVENTORY_TYPE.StorageContainer, inventorySize);
		
		if (!global.MultiplayerMode)
		{
			// TODO: Fix this code
			// CHECK IF CONTAINER HAS ROOM SAVE RECORD
			/*var items = global.GameSaveHandlerRef.GetContainerContentById(containerId);
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
			}*/
		}
	} else {
		var consoleLog = string("Object {0} with instance ID {1} is missing 'containerId'", object_get_name(object_index), id);
		global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		if (global.MultiplayerMode)
		{
			global.NetworkHandlerRef.RequestDisconnectSocket(true);
		} else {
			global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);	
		}
	}
}