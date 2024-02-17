function OnClickActionMenuDelete()
{
	var item = parentElement.targetItem;
	var itemGridIndex = item.grid_index;
	var inventory = item.sourceInventory;
	
	// DELETE ITEM
	if (inventory.RemoveItemByGridIndex(itemGridIndex))
	{
		// NETWORKING DELETE ITEM
		if (global.MultiplayerMode)
		{
			if (IsInventoryContainer(inventory.type))
			{
				var containerInventoryActionInfo = new ContainerInventoryActionInfo(inventory.inventory_id, itemGridIndex, undefined, undefined, undefined, undefined);
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_DELETE_ITEM);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					containerInventoryActionInfo,
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to delete item from container inventory");
				}
			}
		}
		
		// CLOSE ACTION MENU
		global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
	}
}