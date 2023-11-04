function OnPressedGUIDragItemStart(_item)
{
	// SET DRAGGED ITEM
	global.ObjMouse.dragItem = new DragItem(_item);
	
	// REMOVE IT FROM THE SOURCE INVENTORY
	_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
	
	// NETWORKING REMOVE ITEM
	if (global.MultiplayerMode)
	{
		if (_item.sourceInventory.type == INVENTORY_TYPE.LootContainer)
		{
			var containerInventoryActionInfo = new ContainerInventoryActionInfo(_item.sourceInventory.inventory_id, _item.grid_index, undefined, undefined, undefined, undefined);
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM);
			var networkPacket = new NetworkPacket(networkPacketHeader, containerInventoryActionInfo);
			if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
			{
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to remove item from container inventory");
				}
			}
		}
	}
}