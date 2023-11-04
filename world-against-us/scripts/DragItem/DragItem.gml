function DragItem(_item_data) constructor
{
	item_data = _item_data;
	
	original_grid_index = _item_data.grid_index;
	original_is_rotated = _item_data.is_rotated;
	original_is_known = _item_data.is_known;
	
	static RestoreOriginalItem = function()
	{
		var isItemRestored = false;
		var restoredItemGridIndex = item_data.sourceInventory.AddItem(
			item_data, original_grid_index,
			original_is_rotated, original_is_known
		);
		if (!is_undefined(restoredItemGridIndex))
		{
			// NETWORKING RESTORE ITEM
			if (global.MultiplayerMode)
			{
				if (item_data.sourceInventory.type == INVENTORY_TYPE.LootContainer)
				{
					var restoredItem = item_data.sourceInventory.GetItemByGridIndex(restoredItemGridIndex);
					if (!is_undefined(restoredItem))
					{
						var containerInventoryActionInfo = new ContainerInventoryActionInfo(item_data.sourceInventory.inventory_id, undefined, undefined, undefined, undefined, restoredItem);
						var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_ADD_ITEM, global.NetworkHandlerRef.client_id);
						var networkPacket = new NetworkPacket(networkPacketHeader, containerInventoryActionInfo.ToJSONStruct());
						if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
						{
							if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
							{
								show_debug_message("Failed to restore item to container inventory");
							}
						}
					}
				}
			}
			isItemRestored = true;
		} else {
			throw (string("Failed to restore dragged item {0}", item_data.name));
		}
		return isItemRestored;
	}
}