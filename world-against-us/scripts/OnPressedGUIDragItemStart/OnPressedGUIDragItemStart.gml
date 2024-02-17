function OnPressedGUIDragItemStart(_item)
{
	// SET DRAGGED ITEM
	global.ObjMouse.dragItem = new DragItem(_item);
	
	// REMOVE IT FROM THE SOURCE INVENTORY
	_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
	
	// NETWORKING REMOVE ITEM
	if (global.MultiplayerMode)
	{
		if (IsInventoryContainer(_item.sourceInventory.type))
		{
			var containerInventoryActionInfo = new ContainerInventoryActionInfo(_item.sourceInventory.inventory_id, _item.grid_index, undefined, undefined, undefined, undefined);
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_WITHDRAW_ITEM);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				containerInventoryActionInfo,
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				show_debug_message("Failed to remove item from container inventory");
			}
		}
	}
}